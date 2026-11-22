# -*- coding: utf-8 -*-
"""Replace the IDOK button title of every dialog whose OK button reads '中' with '确定'.

BeginUpdateResource/UpdateResource are used so the dialog template may grow.
"""
import ctypes, ctypes.wintypes as wt, struct, sys, shutil, os

k32 = ctypes.WinDLL("kernel32", use_last_error=True)
k32.LoadLibraryExW.restype = wt.HMODULE
k32.LoadLibraryExW.argtypes = [wt.LPCWSTR, wt.HANDLE, wt.DWORD]
k32.FindResourceExW.restype = wt.HANDLE
k32.FindResourceExW.argtypes = [wt.HMODULE, ctypes.c_void_p, ctypes.c_void_p, wt.WORD]
k32.LoadResource.restype = wt.HANDLE
k32.LoadResource.argtypes = [wt.HMODULE, wt.HANDLE]
k32.LockResource.restype = ctypes.c_void_p
k32.LockResource.argtypes = [wt.HANDLE]
k32.SizeofResource.restype = wt.DWORD
k32.SizeofResource.argtypes = [wt.HMODULE, wt.HANDLE]
k32.FreeLibrary.argtypes = [wt.HMODULE]

ENUMPROC = ctypes.WINFUNCTYPE(wt.BOOL, wt.HMODULE, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p)
LANGPROC = ctypes.WINFUNCTYPE(wt.BOOL, wt.HMODULE, ctypes.c_void_p, ctypes.c_void_p, wt.WORD, ctypes.c_void_p)
k32.EnumResourceNamesW.argtypes = [wt.HMODULE, ctypes.c_void_p, ENUMPROC, ctypes.c_void_p]
k32.EnumResourceLanguagesW.argtypes = [wt.HMODULE, ctypes.c_void_p, ctypes.c_void_p, LANGPROC, ctypes.c_void_p]
k32.BeginUpdateResourceW.restype = wt.HANDLE
k32.BeginUpdateResourceW.argtypes = [wt.LPCWSTR, wt.BOOL]
k32.UpdateResourceW.argtypes = [wt.HANDLE, ctypes.c_void_p, ctypes.c_void_p, wt.WORD, ctypes.c_void_p, wt.DWORD]
k32.EndUpdateResourceW.argtypes = [wt.HANDLE, wt.BOOL]

RT_DIALOG = 5
LOAD_AS_DATA = 0x2 | 0x20


def ptr(x):
    return ctypes.c_void_p(x)


def align4(n):
    return (n + 3) & ~3


def walk(buf):
    p = 0
    ver, sig = struct.unpack_from("<HH", buf, p)
    is_ex = (ver == 1 and sig == 0xFFFF)
    p += 4
    if is_ex:
        p += 4
    p += 8
    count, = struct.unpack_from("<H", buf, p)
    p += 2 + 8

    def skip_str(p):
        w, = struct.unpack_from("<H", buf, p)
        if w == 0:
            return p + 2
        if w == 0xFFFF:
            return p + 4
        while struct.unpack_from("<H", buf, p)[0]:
            p += 2
        return p + 2

    if is_ex:
        p = skip_str(p)   # menu
        p = skip_str(p)   # class
        p = skip_str(p)   # title
        p += 6            # point size, weight, italic, charset
        while struct.unpack_from("<H", buf, p)[0]:
            p += 2
        p += 2            # typeface
    else:
        p = skip_str(p)
        p = skip_str(p)
        p = skip_str(p)
    p = align4(p)
    for _ in range(count):
        p += 12 if is_ex else 8
        p += 8
        item_id, = struct.unpack_from("<I", buf, p)
        p += 4
        p = skip_str(p)                 # class
        title_off = p
        p = skip_str(p)                 # title
        title = buf[title_off:p]
        extra, = struct.unpack_from("<H", buf, p)
        p += 2 + extra
        p = align4(p)
        yield item_id, title_off, title


def patch(buf):
    edits = []
    for item_id, toff, title in walk(buf):
        text = title.decode("utf-16le", "ignore").rstrip("\x00")
        if item_id == 1 and text == "中":
            edits.append((toff, len(title)))
    out = buf
    for toff, tlen in reversed(edits):
        out = out[:toff] + "确定".encode("utf-16le") + b"\x00\x00" + out[toff + tlen:]
    return out, len(edits)


def main():
    src = sys.argv[1]
    if not os.path.exists(src + ".orig"):
        shutil.copyfile(src, src + ".orig")
    hmod = k32.LoadLibraryExW(src, None, LOAD_AS_DATA)
    if not hmod:
        print("load failed", ctypes.get_last_error()); return 1

    keys = []
    def cb(h, t, n, lp):
        keys.append(n)
        return True
    k32.EnumResourceNamesW(hmod, ptr(RT_DIALOG), ENUMPROC(cb), None)

    pending = []  # (kind, name, lang, blob)
    for name in keys:
        if name < 0x10000:
            kind, key = "id", name
            name_handle = ptr(name)
        else:
            kind, key = "str", ctypes.wstring_at(name)
            name_handle = ctypes.cast(wt.LPCWSTR(key), ctypes.c_void_p)
        langs = []
        def lcb(h, t, n, l, lp):
            langs.append(l)
            return True
        k32.EnumResourceLanguagesW(hmod, ptr(RT_DIALOG), name_handle, LANGPROC(lcb), None)
        for lang in langs:
            hr = k32.FindResourceExW(hmod, ptr(RT_DIALOG), name_handle, lang)
            if not hr:
                continue
            size = k32.SizeofResource(hmod, hr)
            blob = ctypes.string_at(k32.LockResource(k32.LoadResource(hmod, hr)), size)
            new, n = patch(blob)
            if n:
                pending.append((kind, key, lang, new, n, len(blob)))
    k32.FreeLibrary(hmod)

    if not pending:
        print("no '中' OK buttons found")
        return 2
    hupd = k32.BeginUpdateResourceW(src, False)
    if not hupd:
        print("BeginUpdateResource failed", ctypes.get_last_error()); return 1
    total = 0
    for kind, key, lang, new, n, oldlen in pending:
        name_handle = ptr(key) if kind == "id" else ctypes.cast(wt.LPCWSTR(key), ctypes.c_void_p)
        ok = k32.UpdateResourceW(hupd, ptr(RT_DIALOG), name_handle, lang, new, len(new))
        print("dialog", kind, key, "lang", lang, "buttons", n, "ok", bool(ok), oldlen, "->", len(new))
        total += n
    ok = k32.EndUpdateResourceW(hupd, False)
    err = ctypes.get_last_error()
    print("total buttons patched:", total, "commit ok:", bool(ok), "err", err)
    return 0 if ok and total else 2


if __name__ == "__main__":
    sys.exit(main())

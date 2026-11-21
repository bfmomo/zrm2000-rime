# Weasel TSF 修改版源码（自然码2000）

本目录是 `tsf/weaselx64.dll`、`tsf/weasel.dll` 对应的**完整对应源码**（GPL-3.0）。

## 上游

- 仓库：https://github.com/rime/weasel
- 基线提交：`f96ed24`（2025 年 master；**不是** 0.17.4 标签，实际代码比 0.17.4 新）
- 许可证：GPL-3.0（见上游 `LICENSE.txt`）

## 本版本的改动（4 个文件）

| 文件 | 改动 |
|---|---|
| `WeaselTSF/LanguageBar.cpp` | 帮助文档改为打开随程序安装的 `zrm2000-help.html`（程序目录→用户目录→项目主页）；删除「参加讨论」；「检查新版本」指向本项目 Releases；`open()` 增加 `cmd /c start` 兜底 |
| `WeaselTSF/EditSession.cpp` | 输入条编码末尾补一个空格（仅显示） |
| `WeaselTSF/WeaselTSF.rc` | 三个语言菜单里删除「参加讨论」项（UTF-16 文件，补丁不含二进制差异，全文见 `files/`） |
| `include/WeaselIPCData.h` | `UIStyle` 序列化按 0.16.x 的 69 字段布局对齐：去掉 `vertical_right_to_left`，保留 `vertical_auto_reverse` |

## 目录

- `zrm2000-tsf.patch` — 相对基线提交的 unified diff（文本文件；`.rc` 是 UTF-16，未包含，见下）
- `files/` — 4 个改动后的完整文件（按仓库内路径摆放，可直接覆盖）
- `build/` — 编译所需的两处 shim：`rcshim/afxres.h`（本机无 MFC，rc 需要它）、`boostshim/tss_shim.cpp`（补 `boost::tss_cleanup_implemented`）

## 复现编译（要点）

1. 取上游 `f96ed24` 源码，把 `files/` 覆盖进去。
2. 只需要 ATL（静态库 atls.lib）与 Boost 1.84 头文件 + serialization（自编静态库），**不需要 librime**：TSF 只依赖 WeaselIPC + WeaselUI。
3. 三遍 `cl /c /MT /std:c++17 /utf-8 /EHsc /DBOOST_ALL_NO_LIB`（WeaselIPC、WeaselUI、WeaselTSF）→ `lib` → `rc`（需 `rcshim` 在 include 路径）→ `link /DLL /DEF:WeaselTSF/WeaselTSF.def`，链接 `atls.lib`、`boost_serialization.lib` 及 UI 用到的 d2d1/dwrite/dxgi/d3d11/dcomp/windowscodecs 等。
4. 完整命令行见本仓库的 `docs/方案B-源码重建WeaselTSF.md`（开发机文档），或按上面步骤重建。

## 为什么有这处 UIStyle 改动

本机安装的 WeaselServer 是 0.16.x 时代的 UIStyle（69 字段），与 0.17.4 源码的 70 字段不一致；
不对齐会导致样式（间距、边距、颜色）整体错位。`CandidateInfo`/请求方向两边一致，无需改动。

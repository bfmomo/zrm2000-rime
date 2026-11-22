# Weasel TSF 修改版源码（自然码2000）

本目录是 `tsf/weaselx64.dll`、`tsf/weasel.dll` 对应的**完整对应源码**（GPL-3.0），
另外包含本方案对 `WeaselDeployer.exe` 的资源改动工具。

## 上游

- 仓库：https://github.com/rime/weasel
- 基线提交：`f96ed24`（2025 年 master；**不是** 0.17.4 标签，实际代码比 0.17.4 新）
- 许可证：GPL-3.0（见上游 `LICENSE.txt`）

## 对 WeaselTSF 的改动（4 个文件）

| 文件 | 改动 |
|---|---|
| `WeaselTSF/LanguageBar.cpp` | 帮助文档改为打开随程序安装的 `zrm2000-help.html`（程序目录→用户目录→项目主页）；删除「参加讨论」；「检查新版本」指向本项目 Releases；`open()` 增加 `cmd /c start` 兜底 |
| `WeaselTSF/EditSession.cpp` | 输入条编码末尾补一个空格（仅显示） |
| `WeaselTSF/WeaselTSF.rc` | 三个语言菜单里删除「参加讨论」项（UTF-16 文件，补丁不含二进制差异，全文见 `files/`） |
| `include/WeaselIPCData.h` | `UIStyle` 序列化按 0.16.x 的 69 字段布局对齐：去掉 `vertical_right_to_left`，保留 `vertical_auto_reverse` |

## 对 WeaselDeployer.exe 的改动（资源补丁，不是重新编译）

上游中文资源里，「方案选单设定」对话框的确定按钮写成了 `DEFPUSHBUTTON "中",IDOK`，
我们把它改成「确定」。做法：`tools/patch_deployer_dialog.py` 用 Win32
`BeginUpdateResource/UpdateResource` 替换 RT_DIALOG 里 IDOK 按钮的标题（4 个语言副本）。

    python tools/patch_deployer_dialog.py "C:\Program Files\Rime\weasel-0.17.4\WeaselDeployer.exe"

原文件会备份为 `.orig`。该补丁只改资源，不改代码逻辑。

## 方案列表精简

集成安装包把共享数据目录 `data\` 里除「全拼」依赖外的方案文件移到 `data\_disabled\`，
并在用户目录放一个由 `luna_pinyin` + `luna_quanpin` 合并成的独立 `luna_quanpin.schema.yaml`
（`tools/make_quanpin.py` 生成），这样「方案选单设定」里只剩 自然码2000 和 全拼。

## 目录

- `zrm2000-tsf.patch` — 相对基线提交的 unified diff（文本文件；`.rc` 是 UTF-16，未包含）
- `files/` — 4 个改动后的完整文件（按仓库内路径摆放，可直接覆盖）
- `build/` — 编译所需的两处 shim：`rcshim/afxres.h`、`boostshim/tss_shim.cpp`
- `tools/` — `patch_deployer_dialog.py`（Deployer 资源补丁）、`make_quanpin.py`（全拼方案生成）、`quanpin.schema.yaml`（生成物）

## 复现编译（要点）

1. 取上游 `f96ed24` 源码，把 `files/` 覆盖进去。
2. 只需要 ATL（静态库 atls.lib）与 Boost 1.84 头文件 + serialization（自编静态库），**不需要 librime**。
3. 三遍 `cl /c /MT /std:c++17 /utf-8 /EHsc /DBOOST_ALL_NO_LIB`（WeaselIPC、WeaselUI、WeaselTSF）→ `lib` → `rc`（需 `rcshim` 在 include 路径）→ `link /DLL /DEF:WeaselTSF/WeaselTSF.def`。

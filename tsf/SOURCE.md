# tsf/ 里的两个 DLL 是什么

`weaselx64.dll` / `weasel.dll` 是用 **Rime 小狼毫源码**自行编译的 Weasel TSF（文本服务，x64 / x86）。
Weasel 采用 **GPL-3.0**，因此本仓库同时提供对应源码：

- `tsf/src/` — 改动后的 4 个文件、unified diff、编译所需 shim、复现说明（README.md）
- Release 资产 `zrm2000-tsf-src-1.1.0.zip` — 完整源码树（基于 rime/weasel 提交 `f96ed24`，去掉 .git）

## 上游

https://github.com/rime/weasel （基线提交 `f96ed24`，代码比 0.17.4 标签新）

## 改动摘要

1. `WeaselTSF/LanguageBar.cpp`：帮助文档改为打开随程序安装的 `zrm2000-help.html`（程序目录 → 用户目录 → 项目主页）；删除「参加讨论」；「检查新版本」指向本项目 Releases；`open()` 增加 `cmd /c start` 兜底。
2. `WeaselTSF/EditSession.cpp`：输入条编码末尾补一个空格（仅显示）。
3. `WeaselTSF/WeaselTSF.rc`：三个语言菜单删除「参加讨论」。
4. `include/WeaselIPCData.h`：`UIStyle` 按 0.16.x 的 69 字段布局对齐（本机 WeaselServer 没有 `vertical_right_to_left`）。

## 编译

只编 WeaselTSF + WeaselIPC + WeaselUI，**不需要 librime**；ATL 静态库 + Boost 1.84（头文件与 serialization 自编）。
细节见 `tsf/src/README.md`。

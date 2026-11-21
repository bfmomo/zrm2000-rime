# tsf/ 里的两个 DLL 是什么

`weaselx64.dll` / `weasel.dll` 是用 **Rime 小狼毫 0.17.4 源码**自行编译的 Weasel TSF（文本服务，x64 / x86），
按 GPL-3.0 随本方案分发，源码与改动如下。

## 编译方式

- 只编 WeaselTSF + WeaselIPC + WeaselUI（不需要 librime，TSF 通过命名管道与 WeaselServer 通信）。
- ATL 14.50 静态库、Boost 1.84 serialization 由源码自编，MSVC 14.50 /MT。

## 相对上游 0.17.4 的改动

1. `WeaselTSF/LanguageBar.cpp`
   - 「帮助文档」改为打开随程序安装的 `zrm2000-help.html`：先找 `<WeaselRoot>\zrm2000-help.html`，
     再找 `%APPDATA%\Rime\zrm2000-help.html`，都找不到才打开项目主页。
   - 删除菜单「参加讨论」（三个语言的菜单资源同步删除）。
   - 「检查新版本」改为打开本项目的 Releases 页面（不再走上游 appcast）。
   - `open()` 增加 `cmd /c start` 兜底。
2. `WeaselTSF/EditSession.cpp`：输入条编码末尾补一个空格（仅显示）。
3. `include/WeaselIPCData.h`：`UIStyle` 序列化按 **0.16.x 的 69 字段布局**对齐（本机 WeaselServer 实测没有
   `vertical_right_to_left`，但保留 `vertical_auto_reverse`）。不改这一处，间距/边距等样式值会整体错位。
4. `WeaselTSF/WeaselTSF.rc`：删除三处「参加讨论」菜单项。

上游源码：https://github.com/rime/weasel （tag 0.17.4），许可证 GPL-3.0。

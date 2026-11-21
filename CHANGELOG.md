# 更新记录

## 1.1.0 — 2026-11-21

- 菜单「帮助文档」改为打开随程序安装的 `zrm2000-help.html`：先找程序目录（WeaselRoot），再找 `%APPDATA%\Rime`，都没有才打开项目主页（不再使用 `%PUBLIC%\z.htm`）。
- 移除菜单「参加讨论」：原页面无内容，帮助文档内已有入口。
- 菜单「检查新版本」改指向本项目的 Releases 页面（不再走小狼毫上游的更新源）。
- 安装包新增 `version.json`、`zrm2000-help.html`、`tsf/`（自编译的 Weasel TSF），安装脚本一并处理帮助文件与 TSF（TSF 部分需要管理员）。
- 修正 UIStyle 反序列化：本机 WeaselServer 的 UIStyle 是 0.16.x 的 69 字段版（无 vertical_right_to_left），此前按 0.17.4 字段表解析导致布局值整体错位（间距/边距/阴影全读错），现已逐字段对齐；这也是之前"改间距没反应"的根因。
- 修正 `weasel.custom.yaml`：布局项必须放在 `style/layout/` 下，原来直接写在 `style:` 下被全部忽略。
- 候选间距 `candidate_spacing` 定为 12（配合 `hilite_spacing` 6），候选词与下一个序号之间留白。
- 单字候选后面显示**辅助形码**（输入 `zi` 显示 `aa/bz/pa…`；输入 `zirj` 显示各字自己的形码），由 `lua/zrm_code_hint.lua` 计算。
- 输入条编码末尾补一个空格（仅显示，不进入上屏文本）。
- 依 GPL-3.0 随包提供 TSF 的**对应源码**：`tsf/src/`（补丁 + 4 个改动文件 + 编译说明），Release 另附完整源码包 `zrm2000-tsf-src-1.1.0.zip`。
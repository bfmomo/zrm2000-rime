# 更新记录

## 1.1.0 — 2026-11-21

- 菜单「帮助文档」改为打开随程序安装的 `zrm2000-help.html`（程序目录优先，其次用户目录 `%APPDATA%\Rime`，再退到旧的公用副本与项目主页）。
- 移除菜单「参加讨论」：原页面无内容，帮助文档内已有入口。
- 菜单「检查新版本」改指向本项目的 Releases 页面（不再走小狼毫上游的更新源）。
- 安装包新增 `version.json`、`zrm2000-help.html`、`tsf/`（自编译的 Weasel TSF），安装脚本一并处理帮助文件与 TSF（TSF 部分需要管理员）。
- 修正 UIStyle 反序列化：本机 WeaselServer 的 UIStyle 是 0.16.x 的 69 字段版（无 vertical_right_to_left），此前按 0.17.4 字段表解析导致布局值整体错位（间距/边距全读错），现已逐字段对齐。
- 修正 weasel.custom.yaml：布局项必须放在 style/layout/ 下，原来直接写在 style: 下被全部忽略。
- 候选间距 candidate_spacing 12 → 24，候选词与下一个序号之间留白更明显。
- 单字候选后面显示“剩余编码”（输入 zirj 时 子/自/字/紫/仔 显示 rj），由 lua/zrm_code_hint.lua 计算。
- 输入条编码末尾补一个空格（Weasel 不显示候选码，方案里的 preedit_format 无效，改在 TSF 里给组合串尾部补空格；仅显示，不进入上屏文本）。
- 修复 TSF 与本机 WeaselServer 的 IPC 兼容问题（UIStyle 少一个字段导致 input stream error）。
# 自然码2000 v2 · Rime/小狼毫 64 位复刻包（自动字词句）

自然码2000（V7.27）的 Rime/小狼毫复刻版：64 位可用，字词语句混输、第二辅形、中英标点、自动组句、新词、调频、切形、即时造词。

安装步骤见同目录《安装说明.md》；双拼/形码键位速查见《使用说明.md》。

按申老大提出的五点重做：**第二辅形、标点、语句、新词、调频**。
编码仍是自然码2000 官方码表（2009 新春版 V7.27），运行底盘是 Rime/小狼毫（64 位 TSF）。

## 一、这版解决了什么

| 问题 | v2 做法 | 实测 |
|---|---|---|
| 第二辅形不完整 | 保留官方全部单字 4 码（21,030/21,031 个单字有主形+次形） | deb → 的；debu → 的；uiop → 是 |
| 中英标点别扭 | 编码只用 a-z，`,` `.` 直接出 `，` `。`；Ctrl+Shift+3 切中英标点 | de, → 的，；, → ， |
| 字词/语句要切换 | **同一个方案自动识别**：短码出字词，长码自动组句，不再切方案 | de → 的；jntmtmqi → 今天天气 |
| 缺少新词 | 补 73 万现代词条；62 条常用新词高权重置顶 | 直播带货、区块链、新能源汽车、人工智能 |
| 调频不敏感 | 用户词库 zrm2000.userdb + enable_user_dict；选中即记忆 | 首次选过的词下次同码优先 |

## 二、文件

| 文件 | 说明 |
|---|---|
| zrm2000.schema.yaml | 自动字词句（默认，唯一方案） |
| zrm2000_code.schema.yaml | 可选：官方编码兼容（, . 是编码字符） |
| zrm2000.dict.yaml | 码表：约 215 万条，40 MB |
| custom_phrase.txt | 新词/常用词高权重表（62 条） |
| rime.lua | Lua 扩展入口 |
| lua/ | 切形码表、剩余编码提示、Lua 模块 |
| default.custom.yaml | 方案列表（默认只启用自动方案） |
| weasel.custom.yaml | 小狼毫外观（布局项在 `style/layout/` 下） |
| zrm2000-help.html | 菜单「帮助文档」打开的本地帮助页 |
| tsf/ | 自编译的 Weasel TSF（x64/x86）+ GPL 源码说明；`tsf/src/` 是对应源码 |
| install.ps1 | 安装脚本（普通权限；会调用 install-tsf.ps1） |
| install-tsf.ps1 | 替换输入法程序（管理员，由 install.ps1 弹出 UAC 调起） |
| version.json | 版本与更新源 |

## 三、安装

1. 安装 64 位小狼毫：https://rime.im/download/
2. 在本目录运行：

        powershell -ExecutionPolicy Bypass -File .\install.ps1

   脚本分两步：先以普通权限复制方案/词库/帮助到 `%APPDATA%\Rime`，再**弹出 UAC** 询问是否替换
   输入法程序（管理员运行 `install-tsf.ps1`，替换 System32/SysWOW64/程序目录 4 个 DLL，原文件备份为
   `*.bak-<时间戳>`）。不想换输入法程序就在 UAC 点「否」或先删掉 `tsf` 目录。
   细节见《安装说明.md》第三节。
3. 右键小狼毫托盘图标 -> 重新部署（首次约 30–60 秒，40 MB 码表）。
4. 只需一个方案：**自然码2000**；F4 里不再需要切“字词/语句”。
5. 重启已打开的程序（或注销），新的输入法组件才生效。

## 四、按键与标点

| 按键 | 作用 |
|---|---|
| , . ? ! ; : | 中文标点 ，。？！；： |
| < > ( ) " | 《》（）“” |
| Ctrl+Shift+3 | 中英标点切换（也可 Ctrl+.） |
| Ctrl+Shift+4 | 简/繁切换 |
| Ctrl+Shift+5 | 半角/全角切换 |
| ; / ' | 第 2 / 第 3 候选 |
| [ / ] | 上/下翻页 |
| Shift | 中英输入切换 |
| F4 | 方案选单（只列一个自动方案） |

默认 `,` `.` 是标点，所以 `de,` 上屏「的，」。
要恢复官方「, 是编码」的用法，在 default.custom.yaml 里启用 zrm2000_code 方案，用它输入 `srf,` → 输入法。

## 五、辅码怎么打

不需要切模式，直接在双拼后接主形/次形：

        de   -> 的（声韵）
        deb  -> 的（声韵 + 主形 b）
        debu -> 的（声韵 + 主形 b + 次形 u）
        uiop -> 是

候选框里会同时出现同码的字、词；短码时字词在前，长码时自动追加语句候选。

## 六、自动字词句

同一个方案：
- 2–4 码：单字/词组，含辅码；
- 超过 4 码：自动组句；
- 候选里仍保留精确词条，不会只剩语句。

实测：

        de       -> 的
        deb      -> 的
        debu     -> 的
        srf      -> 输入法
        jntmtmqi -> 今天天气
        wmzirj   -> 我们自然
        womtam   -> 我们他们

## 七、新词与置顶

码表在官方 957,740 条基础上：补入雾凇/腾讯/搜狗现代词，过滤到 2–4 字、常用字，新增约 73 万词条；
custom_phrase.txt 对 62 条常用新词/术语给最高权重，例如：

        直播带货 vbdh    区块链 qkl     新能源汽车 xnyi
        人工智能 rgvn    碳中和 tvh     大数据 duj
        短视频 dup       自媒体 zmt     小程序 xix
        健康码 jkm       自动驾驶 zdju  新质生产力 xvul

需要置顶别的词，在 custom_phrase.txt 加一行：词<Tab>编码<Tab>1000000。

## 八、调频与用户词

- 方案设置 `enable_user_dict: true`、`user_dict: zrm2000.userdb`；
- 选中过的字词会写入用户词库，下次同码优先；
- 想重置调频：关闭小狼毫，删除 %APPDATA%\Rime\zrm2000.userdb 后重新部署。

## 九、与 ZRM2000 的差异

1. 自动组句是 Rime 词图 + 词频，不是黑马神拼；常用句可复现，逐字不会完全一致。
2. 默认标点优先，官方 srf, 这类逗号简码需切到 zrm2000_code 方案。
3. 候选顺序按词频重排，和 2009 原版会有差异；可用 custom_phrase 置顶修正。
4. 用户词库/调频与 ZRM2000 的 ZRW32A.USR 不通用。

## 十、来源与许可

- 编码规则/码表：周志农《自然码2009新春版 V7.27》，Rime 码表整理自 vitszeng/rime-zrm2000。
- 词频与现代词：雾凇拼音（iDvel/rime-ice，Apache-2.0）、腾讯词向量、搜狗标准词库。
- 本包仅用于个人输入法迁移；商业分发需取得原码表授权。

## 十一、切形输入（Alt 加反斜杠）

不知道读音的字，按 Alt 加反斜杠进入切形模式（方案状态显示“切形”），按形码输入：

        ytgu  -> 胡 / 骨 / 臌
        ahah  -> 一 / 二 / 三 / 工 / 王 ...

- 形码取“形1声+形1韵+形2声+形2韵”，输入时不用打两个点；
- 空格或回车选中后自动退出切形，回到正常输入；
- 再按一次 Alt 加反斜杠也可以手动退出；
- 切形码表来自官方“自然切形查询”，11,962 个码、28,886 个字。

## 十二、剩余编码提示

单字/词组候选后面会显示还差哪些编码：

        de    -> 的 (bu)        deb  -> 的 (u)
        wm    -> 我们 (womfp)   srf  -> 输入法 (uurufa)

- 能接上输入的，显示“剩余部分”，如 de 的 bu；
- 接不上的简码，显示完整编码，如 wm 的 (womfp)；
- 切形模式下不显示，避免干扰。

## 十三、输入条样式（v2.2）

参照 ZRM2000 的候选条，重点改两处：

- 笔画偏粗：字体从 Microsoft YaHei UI 16pt 改为 Microsoft YaHei UI Light 14pt；标签 13pt、提示 10pt。
- 候选与正文/编码区分不明显：
  - 输入码：蓝灰 #2F6FB0；
  - 候选字：近黑 #111111；
  - 首候选：深绿底 #2F5D3A + 白字；
  - 标签/提示：灰绿；
  - 候选窗底色浅豆绿 #EAF1E4，边框 #93A98F，带阴影。

另外修正了配色方案的写法：必须放在 preset_color_schemes 下，不能放在 style/color_schemes 下，否则 Weasel 会忽略整套配色。

对比图：docs/weasel-style-compare.png。

想更接近老 ZRM2000 的宋体，可把 font_face 改成 "SimSun"、font_point 保持 14，再部署。

## 十四、标点（v2.2 补）

补齐常用中文标点，尤其是顿号：

| 按键 | 输出 |
|---|---|
| 反斜杠 | 、 |
| / | 、 |
| , . ; : | ， 。 ； ： |
| ^ | …… |
| _ | —— |
| $ | ￥ |
| ~ | ～ |

说明：分号在候选菜单打开时仍是“选第二个候选”（ZRM2000 习惯）；没有候选菜单时输出中文分号。如果你要分号永远输出中文分号，把 key_binder 里的 accept: semicolon, send: 2 删掉即可，但会失去分号选二候选。

之前顿号不出来，是因为 punctuator 只抄了逗号/句号/分号等，漏了反斜杠和斜杠；现已补上，并重新部署。

## 十五、编码尾部与候选序号间距

Weasel 的 candidate_format 前导空格在内联候选条里会被忽略，改用 translator 的 preedit_format，在显示用编码末尾追加一个空格：

    translator:
      preedit_format:
        - "xform/^(.+)$/$1 /"

实测 preedit 显示为 de 加一个空格，候选从 1. 开始，中间有间距。

想更宽就把替换串改成两个空格： "xform/^(.+)$/$1  /"；想更紧就删掉这个 preedit_format。

## 十六、浏览器搜索框兼容

微博搜索框是自定义输入框，对 TSF 内联组合处理不好时，会出现“编码+候选+后续编码”累积（例如 wvb周vvivix...）。

已在 weasel.custom.yaml 的 app_options 中对浏览器关闭内联组合：

    app_options:
      HuaweiBrowser.exe:
        inline_preedit: false
      chrome.exe:
        inline_preedit: false
      msedge.exe:
        inline_preedit: false
      firefox.exe:
        inline_preedit: false

这样 Rime 用独立候选窗，搜索框只接收最终上屏文字。改完需重新部署；浏览器最好也重开一次。

如果换用其他浏览器仍异常，把它的进程名加进 app_options 即可。

## 十七、两行候选条（编码第一行，候选第二行）

已把全局 inline_preedit 设为 false，并显式设置 preedit_type: composition：

- 第一行显示输入编码（候选窗内的独立字体，不使用字处理软件的正文格式）；
- 第二行显示候选汉字，横向排列。

浏览器 app_options 里的 inline_preedit: false 保留，作为微博等自定义输入框的兼容项。

改完需重新部署；Word/浏览器等已打开的应用最好重开一次，让 TSF 重新建立输入上下文。

## 十八、编码与剩余编码配色

- 输入编码：蓝色 #2F6FB0（高亮时 #1F5A9A）；
- 剩余编码：候选注释色 #2F6FB0；选中候选上为浅蓝 #B8D4EE；
- 候选文字：近黑 #111111；
- 候选序号：灰绿 #7C8B78。

剩余编码是 Lua 写入候选 comment 的内容，由 comment_text_color 控制；candidate_format 里加空格会被 Weasel 吃掉，所以用颜色区分。

## 十九、颜色格式修正（重要）

Weasel 默认 color_format 是 abgr（0xAABBGGRR），不是 RGB。之前按 RGB 写 0x2F6FB0，会被解释成橙红色，所以怎么改都不蓝。

现在配色方案里显式写：

    color_format: argb

并把颜色改成 0xAARRGGBB：

- 编码 text_color：0xFF2F6FB0（蓝）
- 高亮编码 hilited_text_color：0xFF1F5A9A
- 剩余编码 comment_text_color：0xFF1E6FD0（亮蓝）
- 选中候选上的剩余编码 hilited_comment_text_color：0xFFA8C8F0（浅蓝）
- 候选文字 candidate_text_color：0xFF111111
- 序号 label_color：0xFF333333（深灰）
- 选中序号 hilited_candidate_label_color：0xFFFFFFFF（白）

这样编码、剩余编码、候选序号、候选文字四种颜色分开。

## 二十、序号与剩余编码的进一步区分

- 序号：深灰 #333333；选中时白色 #FFFFFF；
- 剩余编码：亮蓝 #1E6FD0；选中时浅蓝 #A8C8F0；
- 不再给 comment 加前导空格；之前那个空格已去掉；
- 候选文字：近黑 #111111。

如果仍不够清楚，可以再把 label_font_point 调小、comment_font_point 调大，用字号区分。

## 二十一、四字词被三字词截断

根因不是分词，而是 speller 的 max_code_length 只有 6：

- “华北区”全码 hwbzqu 正好 6 个字母；
- 再输入“域”的 y 时，Rime 认为编码已满，先把“华北区”自动上屏，y 另起一段；
- 于是看起来像“华北区”+“域”两次输入。

修复：

1. max_code_length 从 6 改为 10；
2. custom_phrase.txt 增加高权重条目：

       华北区域  hbqy      1000000
       华北区域  hwbzquy   1000000
       华北区域  hwbzquyu  1000000

四字词在自然码里标准用四字母简码，华北区域就是 hbqy；hwbzquy/hwbzquyu 是兼容全码别名。

其它四字词若也遇到全码截断，优先用四字母简码；确实需要全码，把该词按上面的格式加入 custom_phrase.txt 即可。

## 二十二、没有词时翻页单字组词

码表里没有整词时，候选列表会在精确词之后补上“单字”候选：

- 单字候选由前缀码查单字表得到，例如 wffg 的 wf 段补出“文”等；
- 候选注释显示“单字”；
- 用空格选中单字时，只消耗它的前缀码，剩余编码保留，继续选下一个字。

例子：

    wffg      先出文峰/文风等整词
    翻页      出现 文（单字）
    空格      上屏“文”，候选条剩下 fg
    fg        翻到 锋，空格上屏

这样“孙妍亮”这类码表里没有的名字，可以 孙 + 妍 + 亮 逐字组出来。

实现文件：lua/zrm_single.lua（单字码表）、zrm_single_filter.lua（补候选）、zrm_single_processor.lua（空格局部上屏）。

注意：单字局部上屏可以用空格，也可以按数字键；处理器会拦截两种选法。

## 二十三、六码整词（以孙妍亮为例）

Rime 遇到词表里没有的六码词，会按码表音节拆成 2+4 等段；单字候选只是把这些段显示出来。

已加高权重词条：

    孙妍亮  spyjld  1000000

现在输入 spyjld 的第一候选就是“孙妍亮”，六码保持一个组合，不再先拆“孙/亮”。

其它人名/新词如果也要六码整词，按同样格式加入 custom_phrase.txt 即可。单字逐个选只用于词表里确实没有的词。

## 二十四、单字增强已停用

单字 filter/processor 会干扰 Rime 对长码（六码人名等）的整词/自定义短语翻译，导致出现 2+4 分段。已从 schema 和 rime.lua 中撤掉，恢复原生整码行为。

现在 spyjld 会保持六码一个组合，第一候选“孙妍亮”。

如果以后仍需要“没词时逐字组词”，应做成独立开关/模式，默认不影响正常六码输入。

## 二十五、Tab 单字组词模式（2/3/4 字通用）

正常输入仍然优先走整词，例如：

    spyjld  →  1.孙妍亮

如果词表里没有，或者想自己逐字组：

1. 输入完整编码 spyjld；
2. 按 Tab，编码自动切成 sp'yj'ld；
3. 候选只显示单字，选“孙”；
4. 候选条剩 yj'ld，选“妍”；
5. 剩 ld，选“亮”。

Tab 只在有组合且能切成单字码时生效，平时不影响六码整词。

实现文件：zrm_single.lua、zrm_split_processor.lua、zrm_split_filter.lua。

## 二十六、Tab 组词后自动记住

用 Tab 逐字选完后，会自动把“词 + 完整编码”写入用户目录的 learned_phrases.txt：

    %APPDATA%\Rime\learned_phrases.txt

下次输入同一个完整编码，第一候选会显示这个词，注释“已学”。

例如：

    spyjld → Tab → 选孙、妍、亮
    下次 spyjld → 1.孙妍亮 #已学

保存条件：必须是 Tab 单字模式，并用空格/数字键逐段选中单字；鼠标点选或整段多字候选不会被记录。

实现文件：zrm_learned.lua（读写词表）、zrm_learned_filter.lua（下次置顶）、zrm_split_processor.lua（累计并保存）。

## 二十七、性能修正

排查长码时曾把 translator/enable_completion 设为 true，这会让码表在每次按键做预测扩展查询；2.15M 条码表下明显拖慢输入。已恢复为 false。

同时：

- zrm_single 大表改为按需加载，只有第一次按 Tab 才读；
- learned_filter / split_filter 在无关时直接透传，不再遍历候选。

功能不变：六码整词、Tab 单字组词、组词后自动记住都保留。

## 二十八、六方/单字“六”

Tab 单字模式不再只依赖候选表排序：过滤器会按当前段码从完整单字表补出所有单字，权重只决定先后，低权重字也能翻到并参与组词。

## 二十九、Tab 单字不再漏字

Tab 单字模式会按当前段码从完整单字表补齐候选，权重只影响排序，不会把低权重字排除。

例如 lq'fh' 的 lq 段可以翻到所有 lq 单字，包括不常见的字；选中后继续下一段。

单字表仍是按需加载，普通输入不读它。

## 三十、最终简化：Tab 只切段，其余交给 Rime 原生

已撤掉自定义单字 filter 和自定义数字选择，避免候选页/数字错位。

现在：

- Tab 只把整码切成 ld'wf'fg；
- 每段候选由 Rime 原生给出，所有单字都在，权重只排序；
- 翻页、数字选择、当前段追加形码都用 Rime 原生逻辑；
- 例：yj 段继续输入 nk，变成 yjnk，直接缩到“妍”，不用翻页。

注意：之前那套 learned_phrases 自动记忆已不再挂载；如仍需要，应做成独立组件，不能干扰原生候选/翻页。

## 三十一、自动记忆暂停

自动记忆（learned_phrases）和自定义单字过滤/数字选择会干扰 Rime 原生翻页与形码，已暂停挂载。

现在只保留：Tab 切段 + 单字过滤；翻页、数字、形码全走 Rime 原生。

自动保存词语如要做，应做成独立键/独立模式，不能进入候选链。

## 三十二、原生整词记忆（恢复）

已恢复 Rime 原生的整词记忆：

1. 码表加入 stem 列与 encoder 规则（2/3 字用全码，4 字以上用首字母）；
2. translator 的 enable_encoder / encode_commit_history 生效；
3. 撤掉会改动输入缓冲的 Tab/单字过滤/自定义数字选择等 Lua 组件。

用法：按自然码常规方式逐字输入并选字，例如：

    sp → 选“孙”
    yj → 选“妍”
    ld → 选“亮”

连续输入结束后，Rime 会把“孙妍亮”写入用户词典；下次输入 spyjld 即可召回。

（学习词组按 Rime 规则排在词典既有词之后；无重码的新词会排在前面。）

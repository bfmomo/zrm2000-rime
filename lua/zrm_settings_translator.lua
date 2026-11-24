-- 设置菜单候选：settings_menu 开启时列出各开关当前值
local def = require("zrm_settings_def")

local function translator(input, seg, env)
  local ctx = env.engine.context
  if not ctx:get_option("settings_menu") then return end
  for i, it in ipairs(def) do
    local cur = ctx:get_option(it.name) and it.on or it.off
    local text = string.format("%d  %s：%s", i, it.label, cur)
    yield(Candidate("settings", seg.start, seg._end, text, "(按数字切换)"))
  end
end
return translator

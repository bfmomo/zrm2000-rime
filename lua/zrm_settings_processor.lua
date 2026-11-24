-- Ctrl+Shift+F4：开/关设置菜单；菜单内数字键切换开关；Esc/空格/回车关闭
-- 注：Rime 的 key:repr() 修饰键顺序不定（可能是 Shift+Control+F4），故按子串判断
local def = require("zrm_settings_def")

local function is_toggle_key(r)
  return r:find("F4", 1, true) ~= nil
     and r:find("Control", 1, true) ~= nil
     and r:find("Shift", 1, true) ~= nil
end

local function processor(key, env)
  if key:release() then return 2 end
  local ctx = env.engine.context
  local repr = key:repr()
  if is_toggle_key(repr) then
    local on = ctx:get_option("settings_menu")
    ctx:set_option("settings_menu", not on)
    ctx:refresh_non_confirmed_composition()
    return 1
  end
  if not ctx:get_option("settings_menu") then return 2 end
  local n = tonumber(repr)
  if n and def[n] then
    local it = def[n]
    ctx:set_option(it.name, not ctx:get_option(it.name))
    ctx:refresh_non_confirmed_composition()
    return 1
  end
  if repr == "Escape" or repr == "space" or repr == "Return" then
    ctx:set_option("settings_menu", false)
    ctx:refresh_non_confirmed_composition()
    return 1
  end
  ctx:set_option("settings_menu", false)
  return 2
end
return processor

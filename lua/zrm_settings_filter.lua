-- 设置菜单开启时只显示菜单项，否则隐藏菜单项
local function filter(input, env)
  local on = env.engine.context:get_option("settings_menu")
  for cand in input:iter() do
    if on then
      if cand.type == "settings" then yield(cand) end
    else
      if cand.type ~= "settings" then yield(cand) end
    end
  end
end
return filter

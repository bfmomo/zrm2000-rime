-- 字符集：charset_trad(简/简繁)。trad 集由 tools/build_charset.py 从 OpenCC 生成
local trad = require("zrm_trad")

local function has_trad(s)
  local i, n = 1, #s
  while i <= n do
    local b = s:byte(i)
    local len = 1
    if b >= 0xF0 then len = 4
    elseif b >= 0xE0 then len = 3
    elseif b >= 0xC0 then len = 2 end
    if trad[s:sub(i, i + len - 1)] then return true end
    i = i + len
  end
  return false
end

local function filter(input, env)
  local ctx = env.engine.context
  local show_trad = ctx:get_option("charset_trad")
  if show_trad then
    for cand in input:iter() do yield(cand) end
    return
  end
  for cand in input:iter() do
    local t = cand.text or ""
    if has_trad(t) then
      -- 简：跳过含繁体字的候选
    else
      yield(cand)
    end
  end
end

return filter

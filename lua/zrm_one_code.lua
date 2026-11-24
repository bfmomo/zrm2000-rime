-- 输入 1 码时，只显示 3 个高频单字（首字空格上屏、第2字;、第3字'）
local function filter(input, env)
  local typed = env.engine.context.input
  if #typed ~= 1 then
    for cand in input:iter() do yield(cand) end
    return
  end
  local n = 0
  for cand in input:iter() do
    if n >= 3 then break end
    local t = cand.text or ""
    if #t <= 3 then
      yield(cand)
      n = n + 1
    end
  end
end
return filter

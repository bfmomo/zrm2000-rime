-- 三码以内单字优先：输入码长度 <= 3 时，把单字候选排到词/句候选之前。
-- 单字 UTF-8 占 1~3 字节（汉字 3 字节、ASCII 1 字节），词/句 >= 4 字节，
-- 故用 #cand.text <= 3 判断“单字”。> 3 码时原样透传，不影响长码组句。
local function filter(input, env)
  local ctx = env.engine.context
  if ctx:get_option("freq_first") then
    for cand in input:iter() do yield(cand) end
    return
  end
  local typed = ctx.input
  if #typed > 3 then
    for cand in input:iter() do
      yield(cand)
    end
    return
  end
  local singles, others = {}, {}
  for cand in input:iter() do
    local t = cand.text or ""
    if #t <= 3 then
      table.insert(singles, cand)
    else
      table.insert(others, cand)
    end
  end
  for _, c in ipairs(singles) do yield(c) end
  for _, c in ipairs(others) do yield(c) end
end

return filter

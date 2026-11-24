-- 词语形码部分输入：按 6 码（词码+首末主形）前缀匹配调序，并在注释显示剩余形码
local wh = require("zrm_word_hint")
local function filter(input, env)
  local ctx = env.engine.context
  local typed = ctx.input
  local n = #typed
  if n < 4 or ctx:get_option("shape_mode") then
    for cand in input:iter() do yield(cand) end
    return
  end
  local matched, others = {}, {}
  for cand in input:iter() do
    local code = wh[cand.text]
    if code and #code > n and code:sub(1, n) == typed then
      table.insert(matched, { cand = cand, rest = code:sub(n + 1) })
    else
      table.insert(others, cand)
    end
  end
  for _, m in ipairs(matched) do
    local cm = m.cand.comment or ""
    local newcm = (cm ~= "" and (cm .. " ") or "") .. m.rest
    yield(ShadowCandidate(m.cand, m.cand.type, m.cand.text, newcm, m.cand.preedit))
  end
  for _, c in ipairs(others) do yield(c) end
end
return filter
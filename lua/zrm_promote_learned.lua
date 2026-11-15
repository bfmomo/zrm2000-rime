-- 把自动记忆的词语（注释含 ☯ 且非整句）提升到候选最前
local function promote(input, env)
  local learned = {}
  local rest = {}
  for cand in input:iter() do
    local cm = cand.comment or ""
    if string.find(cm, "\226\152\175", 1, true) and cand.type ~= "sentence" then
      table.insert(learned, cand)
    else
      table.insert(rest, cand)
    end
  end
  for _, c in ipairs(learned) do yield(c) end
  for _, c in ipairs(rest) do yield(c) end
end
return promote

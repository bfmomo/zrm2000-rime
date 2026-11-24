-- 第 2 候选显示快选 ; ，第 3 候选显示快选 '（键位：semicolon->2, apostrophe->3）
local function filter(input, env)
  local i = 0
  for cand in input:iter() do
    i = i + 1
    if (i == 2 or i == 3) and cand.type ~= "settings" then
      local key = (i == 2) and ";" or "'"
      local cm = cand.comment or ""
      local newcm = (cm ~= "" and (cm .. " ") or "") .. key
      yield(ShadowCandidate(cand, cand.type, cand.text, newcm, cand.preedit))
    else
      yield(cand)
    end
  end
end
return filter

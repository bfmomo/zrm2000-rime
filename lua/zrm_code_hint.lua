local hint = require("zrm_hint")

-- 候选后面的编码提示：
--   1) 正在输入的码是候选完整码的前缀 -> 显示还差的那一段（继续打的提示）
--   2) 单字候选、且输入已经打到 3~4 码 -> 显示这个字的“辅助形码”（完整码的后两位），
--      例如输入 zirj 时 子(ziaa) 后面显示 aa，而不是把已输入的 rj 再补一遍
local function is_single(s)
  return utf8.len(s) == 1
end

local function filter(input, env)
  local typed = env.engine.context.input
  local shape_on = env.engine.context:get_option("shape_mode")
  local n = #typed
  if n == 1 then
    for cand in input:iter() do yield(cand) end
    return
  end
  for cand in input:iter() do
    if shape_on then
      yield(cand)
    else
      local code = hint[cand.text]
      local comment = nil
      if code and n > 0 then
        if #code > n and code:sub(1, n) == typed then
          comment = code:sub(n + 1)
        elseif is_single(cand.text) and n >= 3 and #code >= 4 and code ~= typed then
          local head = typed:sub(1, 2)
          local tail = typed:sub(-2)
          if code:sub(1, 2) == head or code:sub(1, 2) == tail then
            comment = code:sub(3)
          end
        end
        if not comment and #code > n and code:sub(1, n) ~= typed then
          comment = "(" .. code .. ")"
        end
      end
      if comment and #comment > 0 then
        yield(ShadowCandidate(cand, cand.type, cand.text, comment, cand.preedit))
      else
        yield(cand)
      end
    end
  end
end

return filter

local hints = require("zrm_hints")

local function filter(input, env)
  local typed = env.engine.context.input
  local shape_on = env.engine.context:get_option("shape_mode")
  for cand in input:iter() do
    if shape_on then
      yield(cand)
    else
      local codes = hints[cand.text]
      local comment = nil
      if codes and #typed > 0 then
        local best = nil
        for _, c in ipairs(codes) do
          if #c > #typed and c:sub(1, #typed) == typed then
            if (not best) or #c > #best then
              best = c
            end
          end
        end
        if best then
          comment = best:sub(#typed + 1)
        else
          local longest = codes[1]
          for _, c in ipairs(codes) do
            if #c > #longest then longest = c end
          end
          if longest and #longest > #typed then
            comment = "(" .. longest .. ")"
          end
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

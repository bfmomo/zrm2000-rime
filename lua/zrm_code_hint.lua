local hint = require("zrm_hint")

local function filter(input, env)
  local typed = env.engine.context.input
  local shape_on = env.engine.context:get_option("shape_mode")
  for cand in input:iter() do
    if shape_on then
      yield(cand)
    else
      local code = hint[cand.text]
      local comment = nil
      if code and #typed > 0 and #code > #typed then
        if code:sub(1, #typed) == typed then
          comment = code:sub(#typed + 1)
        else
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

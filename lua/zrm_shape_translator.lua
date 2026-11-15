local shape = require("zrm_shape")
local pinyin = require("zrm_pinyin")

local function translator(input, seg, env)
  if not env.engine.context:get_option("shape_mode") then
    return
  end
  local chars = shape[input]
  if not chars then
    return
  end
  for _, ch in ipairs(chars) do
    local code = pinyin[ch] or ""
    yield(Candidate("shape", seg.start, seg._end, ch, code))
  end
end

return translator

-- 双字词之后追加单字候选（Phrase 候选，可被记忆）
local function init(env)
  env.mem = Memory(env.engine, env.engine.schema)
end

local function translate(input, seg, env)
  if #input ~= 4 then return end
  if env.engine.context:get_option("shape_mode") then return end
  local c1 = input:sub(1, 2)
  local c2 = input:sub(3, 4)
  if env.mem:dict_lookup(c1, false, 200) then
    for e in env.mem:iter_dict() do
      yield(Phrase(env.mem, "table", seg.start, seg.start + 2, e):toCandidate())
    end
  end
  if env.mem:dict_lookup(c2, false, 200) then
    for e in env.mem:iter_dict() do
      yield(Phrase(env.mem, "table", seg.start + 2, seg.start + 4, e):toCandidate())
    end
  end
end

return { init = init, func = translate }

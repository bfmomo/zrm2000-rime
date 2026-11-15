local function filter(input, env)
  local on = env.engine.context:get_option("shape_mode")
  for cand in input:iter() do
    if (not on) or cand.type == "shape" then
      yield(cand)
    end
  end
end

return filter

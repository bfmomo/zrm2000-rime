local function processor(key, env)
  local ctx = env.engine.context
  if not ctx:get_option("shape_mode") then
    return 2
  end
  local repr = key:repr()
  if repr == "space" or repr == "Return" then
    local cand = ctx:get_selected_candidate()
    if cand then
      env.engine:commit_text(cand.text)
      ctx:clear()
      ctx:set_option("shape_mode", false)
      return 1
    end
  end
  return 2
end

return processor

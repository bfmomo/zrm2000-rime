-- 模式提示已改由原生 WeaselPanel 画在编码行右侧（IPC ctx.mode），
-- 这里保留一个空过滤器（兼容 schema 的 filters 配置），不再往候选注释追加。
local function filter(input, env)
  for cand in input:iter() do yield(cand) end
end
return filter

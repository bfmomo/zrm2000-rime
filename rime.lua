-- 自然码2000 v2 Lua 扩展
shape_translator = require("zrm_shape_translator")
shape_filter = require("zrm_shape_filter")
shape_processor = require("zrm_shape_processor")
code_hint = require("zrm_code_hint")
promote_learned = require("zrm_promote_learned")
append_single = require("zrm_append_single")

function commit_notifier(ctx)
  if ctx:get_option("shape_mode") then
    ctx:set_option("shape_mode", false)
  end
end

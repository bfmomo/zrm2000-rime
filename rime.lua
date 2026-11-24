-- 自然码2000 v2 Lua 扩展
shape_translator = require("zrm_shape_translator")
shape_filter = require("zrm_shape_filter")
shape_processor = require("zrm_shape_processor")
code_hint = require("zrm_code_hint")
single_priority = require("zrm_single_priority")
charset = require("zrm_charset")
settings_translator = require("zrm_settings_translator")
settings_processor = require("zrm_settings_processor")
settings_filter = require("zrm_settings_filter")
mode_display = require("zrm_mode_display")
append_single = require("zrm_append_single")
one_code = require("zrm_one_code")
quick_hint = require("zrm_quick_hint")
word_shape = require("zrm_word_shape")

function commit_notifier(ctx)
  if ctx:get_option("shape_mode") then
    ctx:set_option("shape_mode", false)
  end
end

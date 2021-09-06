-- Sets up all non built-in gameplay features specific to this quest.

-- Usage: require("scripts/features")

-- Features can be enabled to disabled independently by commenting
-- or uncommenting lines below.


--require("scripts/coroutine_healper")
--require("scripts/language_manager")
--require("scripts/mouse_control")
require("scripts/debug")
require("scripts/console")
require("scripts/menus/alttp_dialog_box")
require("scripts/menus/pause")
require("scripts/menus/game_over")
require("scripts/hud/hud")

return true

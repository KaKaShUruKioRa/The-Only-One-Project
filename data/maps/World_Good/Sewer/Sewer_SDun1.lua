-- Lua script of map World_Good/Sewer/Sewer_SDungeon1.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
if game:get_value("Sewer_Wwall_Exploded") then
Sewer_SDungeon1_Wwall_Wall:set_enabled(false)
Sewer_SDungeon1_Wwall_Bord:set_enabled(false)
Sewer_SDungeon1_Wwall_TopDoor:set_enabled(true)
end
end

function Sewer_SDungeon1_Wwall:on_opened()
Sewer_SDungeon1_Wwall_Wall:set_enabled(false)
Sewer_SDungeon1_Wwall_Bord:set_enabled(false)
Sewer_SDungeon1_Wwall_TopDoor:set_enabled(true)
end


function map:on_opening_transition_finished()

end
-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

-- Lua script of map Dungeon1/B1/B1_Recompense.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
if game:get_value("bomb_obtained") then
B1_Recompense_Warp_TP:set_enabled(true)
end
end

function bomb_big_chest:on_opened()
  hero:start_treasure("inventory/bombs", nil, nil, function()
                      B1_Recompense_Warp_TP:set_enabled(true)
                                         end)
end

function map:on_opening_transition_finished()

end

-- Lua script of map Dungeon1/F2/F2_Flooded.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
end

for Torches in map:get_entities("torch_light_") do
  function Torches:on_lit()
    if torch_light_1:is_lit() and torch_light_2:is_lit() and torch_light_3:is_lit() and torch_light_4:is_lit() then
      F2_Flooded_Chest:set_enabled(true)
      sol.audio.play_sound("chest_appears")
    else
      
    end
  end
end


function map:on_opening_transition_finished()

end

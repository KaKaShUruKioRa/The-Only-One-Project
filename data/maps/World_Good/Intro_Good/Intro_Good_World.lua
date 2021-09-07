-- Lua script of map World_Good/Intro_Good/World_Intro_Good.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local RNGdrop = require("scripts/algo/random_destructible") 

------------------------------------------------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
------------------------------------------------------------------------------

 RNGdrop:enemies()
 RNGdrop:destructibles()

------------------------------------------------------------------------------
------------------------------------------------------------------------------

function map:on_started()

  if game:get_value("Container_Heart_1") then
    local x, y = block_cave_locked:get_position()
    block_cave_locked:set_position(x + 20, y)
    pullingsoldier:set_position(x + 38, y)
    NGuard:set_position(x + 38, y + 16)
    SGuard:set_position(x, y + 64)
  end

  function NGuard:on_interaction()
    if game:get_value("Container_Heart_1") then
     game:start_dialog("Intro_World_Good.NGuard")
    end
  end

  function SGuard:on_interaction()
    if game:get_value("Container_Heart_1") then
      game:start_dialog("Intro_World_Good.NGuard")
    end 
  end

  function Intro_Good_World_HLDoor_Capt:on_activated()
    Intro_Good_World_HLDoor:set_enabled(false)
    sol.audio.play_sound("door_open")
    Intro_Good_World_HLDoor_Capt:set_enabled(false)
  end
  function Dungeon1_Door_Capt:on_activated()
    dungeon1_door:set_enabled(false)
    sol.audio.play_sound("door_open")
    Dungeon1_Door_Capt:set_enabled(false)
  end
end

------------------------------------------------------------------------------

for separators in map:get_entities("separ_") do
  function separators:on_activating(direction4)
    Intro_Good_World_HLDoor:set_enabled(true)
    pushingdoor:set_enabled(true)
    pushingDun1door:set_enabled(true)
    dungeon1_door:set_enabled(true)
  end
end

------------------------------------------------------------------------------

function pushingdoor:on_activated_repeat() -- Ouvrir la porte de la maison de Link
   if hero:get_state() == "pushing" then
      pushingdoor:set_enabled(false)
      Intro_Good_World_HLDoor:set_enabled(false)
      sol.audio.play_sound("door_open")
      hero:unfreeze()
   end
end 

------------------------------------------------------------------------------

function pushingDun1door:on_activated_repeat() -- Ouvrir la porte du donjon
   if hero:get_state() == "pushing" then
      pushingDun1door:set_enabled(false)
      dungeon1_door:set_enabled(false)
      sol.audio.play_sound("door_open")
      hero:unfreeze()
   end
end 


------------------------------------------------------------------------------

function map:on_opening_transition_finished()

end
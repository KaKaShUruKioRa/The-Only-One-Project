local map = ...
local game = map:get_game()
local RNGdrop = require("scripts/algo/random_destructible") 

--------------------------------------------------------------------
--------------------------------------------------------------------

 RNGdrop:enemies()
 RNGdrop:destructibles()

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

local torch_lit = false
local pingous_dead = false
local posX, posY, posL = 0, 0, 0

---------------------------------------------------------------------------------------

local function ice_key()
          if pingous_dead == true and torch_lit == true then
            pingous_key:set_enabled(true)
            pingous_key:set_position(posX, posY, posL)
            sol.audio.play_sound("chest_appears")
          end
      end

---------------------------------------------------------------------------------------

local function verif_torches_lit()
        for Torches in map:get_entities("torch_light_") do
          function Torches:on_lit()
            if torch_light_1:is_lit() and torch_light_2:is_lit() and torch_light_3:is_lit() and torch_light_4:is_lit() then
               B1_Ice_EDoor:open()
               dark_room:set_enabled(false)
               torch_lit = true
               ice_key()
            end
          end
        end
      end

---------------------------------------------------------------------------------------

local function verif_dead_pingous()
        for Pingous in map:get_entities("pingou_") do
          function Pingous:on_dead()
            if map:get_entities_count("pingou_") == 0 then
               posX, posY, posL = Pingous:get_position()
               pingous_dead = true
               ice_key()
            end
          end
        end
      end

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

function map:on_started()
  RNGdrop:enemies(map)
  RNGdrop:destructibles(map)
  if game:get_value("pingous_key_obtained") then
      for Torches in map:get_entities("torch_light_") do
        Torches:set_lit(1)
      end
    dark_room:set_enabled(false)
    Closer_freeze_capt:set_enabled(false)
  else
    verif_torches_lit()
    verif_dead_pingous()
  end
end

---------------------------------------------------------------------------------------

function Closer_freeze_capt:on_activated()
  B1_Ice_EDoor:set_enabled(true)
  B1_Ice_EDoor:close()
  Closer_freeze_capt:set_enabled(false)
end

---------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------

function map:on_opening_transition_finished()

end
local map = ...
local game = map:get_game()
local RNGdrop = require("scripts/algo/random_destructible") 

--------------------------------------------------------------------
--------------------------------------------------------------------

 RNGdrop:enemies()
 RNGdrop:destructibles()

--------------------------------------------------------------------
--------------------------------------------------------------------

local posX, posY, posL = 0, 0, 0

local function keylootondead()
        for Soldiers in map:get_entities("Soldier_") do
          function Soldiers:on_dead()            
              if map:get_entities_count("Soldier_") == 0 then
                posX, posY, posL = Soldiers:get_position()
                soldiers_key:set_enabled(true)
                soldiers_key:set_position(posX, posY, posL)
                sol.audio.play_sound("chest_appears")
              end
          end
        end
      end
--
--

function map:on_started()
  if not game:get_value("soldiers_key_obtained") then
    keylootondead()
  end
end

--


function IndiceHitHeart:on_interaction()
           game:start_dialog("Indices.IndiceQuestion", function(answer)
                                     if answer == 3 then -- 3 ligne de la box : Oui
                                        game:start_dialog("Indices.HitHeart") -- Afficher l'Indice lié à la plaque 
                                     else -- 4 ligne (ou autres) : Non / Ne rien faire.
                                     end 
                                                        end)           
   end

--

function map:on_opening_transition_finished()

end

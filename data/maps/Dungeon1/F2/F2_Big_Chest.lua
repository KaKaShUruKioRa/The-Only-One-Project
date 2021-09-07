local map = ...
local game = map:get_game()
local RNGdrop = require("scripts/algo/random_destructible") 

--------------------------------------------------------------------
--------------------------------------------------------------------

 RNGdrop:enemies()
 RNGdrop:destructibles()

------------------------------------------------------------
------------------------------------------------------------

local function TargetsVerif()
  for Switches in map:get_entities("switch_hole_") do
    function Switches:on_activated()
      if switch_hole_1:is_activated() and switch_hole_2:is_activated() and switch_hole_3:is_activated() and switch_hole_4:is_activated() then 
        sol.audio.play_sound("chest_appears")
        map:set_entities_enabled("block_hole_", false)
           if switch_hole_5:is_activated() and switch_hole_6:is_activated() then
             map:set_entities_enabled("hole_big_chest_", false)
             sol.audio.play_sound("chest_appears")
            lantern_chest:set_enabled(true)
          end
      end
    end
  end
end

---
---

function map:on_started()
  if not game:get_value("Lantern_Obtained") then 
   TargetsVerif()
  else
    map:set_entities_enabled("block_hole_", false)
    map:set_entities_enabled("hole_big_chest_", false)
    map:set_entities_enabled("block_arrow_", false)
    lantern_chest:set_enabled(true)
  end
end

--

function IndiceFragile:on_interaction()
           game:start_dialog("Indices.IndiceQuestion", function(answer)
                                     if answer == 3 then -- 3 ligne de la box : Oui
                                        game:start_dialog("Indices.HelpFragile") -- Afficher l'Indice lié à la plaque 
                                     else -- 4 ligne (ou autres) : Non / Ne rien faire.
                                     end 
                                                        end)           
   end

--

function map:on_opening_transition_finished()

end

local map = ...
local game = map:get_game()
local RNGdrop = require("scripts/algo/random_destructible") 

--------------------------------------------------------------------
--------------------------------------------------------------------

 RNGdrop:enemies()
 RNGdrop:destructibles()

--------------------------------------------------------------------
--------------------------------------------------------------------

local function pulldoor()
                       function pullingdoor:on_activated_repeat()
                          if game:get_money() >= 20 and hero:get_state() == "pulling" and doorsteal_opened == nil then
                             pullingdoor:set_enabled(false)
                             game:remove_money(20)
                             doorsteal:open()
                          end
                        end 
end

--------------------------------------------------------------------
--------------------------------------------------------------------

function map:on_started()
  if not game:get_value("doorsteal_opened") then
   pulldoor()
  end
end

---------------------------------------------

  function ennemistrap:on_activated()
  
       map:set_entities_enabled("sableux_", true) -- les ennemies apparaisent
       map:set_entities_enabled("door_fight_", true) -- les portes se ferme.
       sol.audio.play_sound("door_closed") 
       ennemistrap:remove()
 for sableux in map:get_entities("sableux_") do 
 function sableux:on_dead()
    local numsableux = map:get_entities_count("sableux_") -- A la mort d'un sableux enleve 1 au counter
     if numsableux == 0 then -- si la counter est vide alors les portes s'ouvrent et le jeu se suspend
        game:set_suspended(true)
        map:open_doors("door_fight_")
       function map:on_command_pressed(command) -- dès que le joueur appuie sur une touche, le jeu repart.
         if game:is_suspended() then
           game:set_suspended(false)
         end
       end
     end
  end
end 
  end
     
-------------------------------------------------

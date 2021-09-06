local map = ...
local game = map:get_game()
local RNGdrop = require("scripts/algo/random_destructible") 

--------------------------------------------------------------------
--------------------------------------------------------------------

 RNGdrop:enemies()
 RNGdrop:destructibles()

--------------------------------------------------------------------
--------------------------------------------------------------------

function map:on_started()
  DoorFightAfterBassin:open() 
    if game:get_value("fighter_dead") then
     map_chest:set_enabled(true)
    end
end

--------------------------------------------------------------------

function enterinroom:on_activated()
   DoorFightAfterBassin:close()    
end

--------------------------------------------------------------------

for fighters in map:get_entities("fighter_") do
function fighters:on_dead()
local numfighters = map:get_entities_count("fighter_")
     if numfighters == 0 then -- si la counter est vide alors les portes s'ouvrent et le jeu se suspend
        game:set_suspended(true)
        DoorFightAfterBassin:open()
        sol.audio.play_sound("chest_appears")
        map_chest:set_enabled(true)
        enterinroom:remove()
        game:set_value("fighters_dead", true)
       function map:on_command_pressed(command)-- dès que le joueur appuie ou relache sur une touche, le jeu repart.
         if game:is_suspended() then
           game:set_suspended(false)
         end
       end
     end
  end
end 
     
-------------------------------------------------
local map = ...
local game = map:get_game()
local RNGdrop = require("scripts/algo/random_destructible") 

--------------------------------------------------------------------
--------------------------------------------------------------------

 RNGdrop:enemies()
 RNGdrop:destructibles()

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------

local function secretfound()
            sol.audio.play_sound("secret")
            game:set_value("secretfound", true)
            murnord:set_position(144, 0, 1)
            updoor:set_position(144, 16 , 1)
            hero:unfreeze()
end

-------------------------------------------------------------------------------

local function Arrow_Switches_on_activated(arrow_switches)
    if arrow_switch_1:is_activated() == true and arrow_switch_2:is_activated() == true then
      Lamainquifaitchier:remove()
      hero:freeze()

      timer_count = 0
         sol.timer.start(1000, function() 
                             sol.audio.play_sound("enemy_awake") 
                             timer_count = timer_count + 1
                                if timer_count < 4 then 
                                  return true
                                else 
                                  hero:unfreeze()
                                  sol.audio.play_sound("secret") 
                                  game:start_dialog("Dungeon1.ArrowSecret")
                                  game:set_value("arrow_switches_activated", true)
                                  return false
                                end
                                    end)
        end
    end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

for secreters in map:get_entities("secreter_") do
  function secreters:on_dead()
       if map:get_entities_count("secreter_") == 0 then -- si la counter est vide alors les portes s'ouvrent et le jeu se suspend
          game:set_value("secreters_dead", true)
             local timer_count = 0
                hero:freeze()
                Lamainquifaitchier:remove()
                  for SecretDoors in map:get_entities("Door_Secret_") do
                    sol.timer.start(1750, function()
                                                local pos = SecretDoors:get_position()
                                                  if SecretDoors:get_name() == "Door_Secret_1" and timer_count < 4 then
                                                     sol.audio.play_sound("enemy_awake")
                                                     SecretDoors:set_position(pos - 8, 16, 1)
                                                     timer_count = timer_count + 1
                                                     return true
                                                  elseif SecretDoors:get_name() == "Door_Secret_2" and timer_count < 4 then
                                                    sol.audio.play_sound("enemy_awake")
                                                    SecretDoors:set_position(pos + 8, 16, 1)
                                                    timer_count = timer_count + 1
                                                    return true
                                                  else
                                                    return false
                                                  end                                              
                                          end)
                  end
            sol.timer.start(3500, secretfound)
         
       end
    end
end 


-------------------------------------------------------------------------------

function map:on_started()
    if game:get_value("secretfound", true) then
       map:set_entities_enabled("secreter_magi_", false)
         if not game:get_value("GourouSwitch_actived") then
            murnord:set_position(144, 0, 1)
            updoor:set_position(144, 16 , 1)
            Door_Secret_1:set_position(136 - 16, 16, 0)
            Door_Secret_2:set_position(160 + 16, 16, 0)
         end
    end
end


-------------------------------------------------------------------------------

function IndiceGourou:on_interaction()
           game:start_dialog("Indices.IndiceQuestion", function(answer)
                                     if answer == 3 then -- 3 ligne de la box : Oui
                                        game:start_dialog("Indices.HelpGourou") -- Afficher l'Indice lié à la plaque 
                                     else -- 4 ligne (ou autres) : Non / Ne rien faire.
                                     end 
                                                        end)           
   end

-------------------------------------------------------------------------------

for arrow_switches in map:get_entities("arrow_switch_") do
arrow_switches.on_activated = Arrow_Switches_on_activated
end
-------------------------------------------------------------------------------

function map:on_opening_transition_finished()

end

local map = ...
local game = map:get_game()

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
function map:on_started()
   if game:get_value("palmchest") then
               TakeChestFirst:open()
        end
   if game:get_value("arrow_switches_activated") then
          for BigDoors in map:get_entities("BigDoor_Bassin_") do
            pos = BigDoors:get_position()
              if BigDoors:get_name() == "BigDoor_Bassin_1" then
                BigDoors:set_position(pos - 16, 16, 1)
              elseif BigDoors:get_name() == "BigDoor_Bassin_2" then
                BigDoors:set_position(pos + 16, 16, 1)
              end
          end
        exploded_door_top:set_enabled(true)
    end
end

local function secret_drain()
           sol.audio.play_sound("secret")
           hero:freeze()
           sol.timer.start(500,function()
                              sol.audio.play_sound("water_drain_begin")
                                end)
       end
--------------------------------------------------------------------------------

        function watertodrain_Capt:on_activated()
        
         --  local timer_count = 0 -- On donne la valeur 0 à un compteur
           local watertodrain_index = 1
              sol.timer.start(100, secret_drain)
              sol.timer.start(750,function()     
                                 sol.audio.play_sound("water_drain")
                                 local ptile = map:get_entity("watertodrain_" .. watertodrain_index)
                                 local ntile = map:get_entity("watertodrain_" .. (watertodrain_index +1))
                                 ptile:set_enabled(false)
                                    if ntile == nil then
                                     hero:unfreeze()
                                     stairwater:set_enabled(true)
                                    return false
                                    end
                                 ntile:set_enabled(true) 
                                 watertodrain_index = watertodrain_index + 1
                                 return true
                                -- timer_count = timer_count + 1 -- Le compteur est incrémenté de 1   
                                -- return timer_count < 6 --redémarre la fonction jusqu'à ce que le compteur soit à 6
                                   end)
           watertodrain_Capt:set_enabled(false)  
           game:set_value("waterdrained", 1)
        end

---------------------------------------------------------------------------------
      
            if game:get_value("waterdrained") then
                      --Si l'eau a été drainée alors
              map:set_entities_enabled("watertodrain_1",false)
              stairwater:set_enabled(true)
              watertodrain_Capt:set_enabled(false)
            else
              stairwater:set_enabled(false)
        -- Sinon l'eau est apparante et l'échelle n'est pas fonctionnelle
            end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------



function palmchest:on_opened()
  palmchest:set_treasure("equipment/flippers", 1, "palmchest")
  hero:start_treasure("equipment/flippers", 1)
  TakeChestFirst:open()
end


local map = ...
local game = map:get_game()

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

    function map:on_started() --La map a démarré et execute les functions incluses dans cette functoin map:on_started()

        function EnfermeLeHero:on_activated()
           sol.audio.play_sound("secret")
            map:set_entities_enabled("piege",true) --ce fonction remplace les deux lignes du dessous, en vérifiant toutes les entités de la map ayant le nom "piege..."
           --piege1:set_enabled(true)
           --piege2:set_enabled(true)
           game:set_value("piegeactivated", 1)
        end

---------------------------------------------------------------------------------
      
            if game:get_value("enable_map_chest_dun1") then
                      --Si Coffre a été ouvert alors
              chest_switch:set_activated(true)
            else
              map_chest_dun1:set_enabled(false)
        -- Sinon le coffre reste caché et le bouton inactivé
            end

---------------------------------------------------------------------------------

            if game:get_value("piegeactivated") then
                      --Si le piège a été activé alors les piege sont activé
               map:set_entities_enabled("piege",true)
            else

        -- Sinon les pièges reste inactivé
            end

    end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

    function chest_switch:on_activated()
      sol.audio.play_sound("chest_appears")
      map_chest_dun1:set_enabled(true)
      game:set_value("enable_map_chest_dun1", 1)
    end

---------------------------------------------------------------------------------

local function secret_drain()
           sol.audio.play_sound("secret")
           hero:freeze()
           sol.timer.start(500,function()
                              sol.audio.play_sound("water_drain_begin")
                                end)
       end

        function watertodrain_Capt:on_activated()
        
         --  local timer_count = 0 -- On donne la valeur 0 à un compteur
           local watertodrain_index = 1
              sol.timer.start(100,secret_drain)
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
                      --Si l'eau a été drainé alors
              map:set_entities_enabled("watertodrain_1",false)
              stairwater:set_enabled(true)
              watertodrain_Capt:set_enabled(false)
            else
              stairwater:set_enabled(false)
        -- Sinon l'eau est apparante
            end
    
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

local function secret_drain()
           sol.audio.play_sound("secret")           
           sol.timer.start(500,function()
                              sol.audio.play_sound("water_drain_begin")
                                end)
       end

----------------------------------------------------------------------------------

    if game:get_value("palmchest") then
        function watertofill_Capt:on_activated()
               hero:freeze()
          local watertofill_index = 1
              sol.timer.start(100,secret_drain)
              sol.timer.start(750,function()     
                                 sol.audio.play_sound("water_drain")
                                 local ptile = map:get_entity("watertofill_" .. watertofill_index)
                                 local ntile = map:get_entity("watertofill_" .. (watertofill_index +1))
                                 ptile:set_enabled(true)
                                    if ntile == nil then
                                       hero:teleport("Dungeon1/DroiteBassin","_same","immediate")                                    
                                       return false
                                    end
                                 ntile:set_enabled(false)      
                                      sol.timer.start(750,function()
                                                            ptile:set_enabled(false)
                                                      end)   
                                 watertofill_index = watertofill_index + 1
                                 return true
                                   end)                               
           watertofill_Capt:set_enabled(false)
           game:set_value("waterfilled", 1)
        end
    end

---------------------------------------------------------------------------------
      
            if game:get_value("waterfilled") then
                      --Si l'eau a été drainé alors
              watertofill_9:set_enabled(true)  
              watertofill_Capt:set_enabled(false)            
            else               
        -- Sinon l'eau est apparante
            end
    
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function map:on_opening_transition_finished() -- A la fin de la transition d'ouverture de la map
end
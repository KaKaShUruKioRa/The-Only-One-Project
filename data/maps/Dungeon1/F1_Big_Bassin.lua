local map = ...
local game = map:get_game()

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

local watertofill_index = 1

---------------------------------------------------------------------------------

local function secret_fill()          
           sol.timer.start(500,function()
                              sol.audio.play_sound("water_fill_begin")
                                end)
       end


---------------------------------------------------------------------------------

local function water_fill()     
    sol.audio.play_sound("water_fill")
    local ptile = map:get_entity("watertofill_" .. watertofill_index)
    local ntile = map:get_entity("watertofill_" .. (watertofill_index +1))
    ptile:set_enabled(true)
       if ntile == nil then
          hero:teleport("Dungeon1/F1_Big_Bassin","_same","immediate")                                    
          return false
       end
          ntile:set_enabled(false)      
          sol.timer.start(1000,function()
                           ptile:set_enabled(false)
                                end)   
          watertofill_index = watertofill_index + 1
          return true
      end 
 
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

    function map:on_started() --La map a démarré et execute les functions incluses dans cette functoin map:on_started()
    if  game:get_value("fighters_dead") then
        function watertofill_Capt:on_activated()
                hero:freeze()
                trap_BigBassin:set_enabled()
                trap_BigBassin:close()
              sol.timer.start(500,secret_fill)
              sol.timer.start(1000, water_fill)                            
           watertofill_Capt:set_enabled(false)
           game:set_value("waterfilled", true)
        end
    end

---------------------------------------------------------------------------------
      
            if game:get_value("waterfilled") then
                      --Si l'eau a été drainé alors
              watertofill_9:set_enabled(true)  
              watertofill_Capt:set_enabled(false)            
            end  -- Sinon l'eau est apparante
    end

------------------------------------------------------------------------------------------------------------------------------------------------------------------

function map:on_opening_transition_finished() -- A la fin de la transition d'ouverture de la map
end
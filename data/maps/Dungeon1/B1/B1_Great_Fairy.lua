-- Lua script of map Dungeon1/B1/great_fairy.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
  if game:get_value("To_Fairies_Activated") then
    if game:get_value("To_Fairies_Activated") == 2 then
      sol.timer.start(611, function() 
                      hero:freeze() 
                      sol.audio.play_sound("water_drain_begin")
                            end)
      sol.timer.start(2500, function() 
                      map:set_entities_enabled("To_Fairies_", true)   
                      sol.audio.play_sound("water_drain")
                      hero:unfreeze()
                      game:set_value("To_Fairies_Activated", 3)
                             end)
    elseif game:get_value("To_Fairies_Activated") > 2 then
      map:set_entities_enabled("To_Fairies_", true)
      sol.audio.play_sound("item_in_water")
    end
  end
end

function great_fairy_capt:on_activated()
    sol.audio.play_music("great_fairy")
    hero:freeze()
    great_fairy_hammer:set_enabled(true)
           game:start_dialog("Dungeon1.GreatFairy.Ask", function(answer)
                                 if answer == 3 and game:get_life() == game:get_max_life() then -- 3 : J'ai besoin de soins + Full PV
                                    game:start_dialog("Dungeon1.GreatFairy.UselessHeal", function() 
                                                               great_fairy_hammer:set_enabled(false) 
                                                               hero:unfreeze() 
                                                                                         end)
                                 elseif answer == 3 and game:get_life() ~= game:get_max_life() then -- 3 : J'ai besoin de soins + pas full PV
                                    game:start_dialog("Dungeon1.GreatFairy.Heal", function() 
                                                               great_fairy_hammer:set_enabled(false) 
                                                               game:set_life(game:get_max_life())
                                                               hero:unfreeze() 
                                                                                  end)
                                 elseif answer == 4 and game:has_item("inventory/hammer") == false then-- 4 : As-tu quelque chose pour moi + No Hammer
                                    game:start_dialog("Dungeon1.GreatFairy.Search", function ()
                                      local timer_counter = 1
                                      local index = 1
                                       great_fairy_hammer:set_enabled(false)
                                       sol.timer.start(750, function() 
                                                        if timer_counter <= 6 then
                                                           splashes = map:get_entity("splash_"..index)
                                                           splashes:set_enabled(true)
                                                           sol.audio.play_sound("walk_on_water")
                                                           timer_counter = timer_counter + 1
                                                           index = index + 1
                                                           return true 
                                                         else 
                                                           great_fairy_hammer:set_enabled(true)
                                                           game:start_dialog("Dungeon1.GreatFairy.GiveItem", function()     
                                                                 hero:start_treasure("inventory/hammer", 1, "possession_hammer", function() 
                                                                        great_fairy_hammer:set_enabled(false) 
                                                                        hero:unfreeze()
                                                                                                                                   end)
                                                                                                              end)
                                                                            return false 
                                                                          end
                                                             end)
                                                                                   end)
                                     elseif answer == 4 and game:has_item("inventory/hammer") == true then-- 4 : As-tu quelque chose pour moi + Marteau déjà obtenu
                                          game:start_dialog("Dungeon1.GreatFairy.NoMoreItem", function() 
                                                               great_fairy_hammer:set_enabled(false) 
                                                               hero:unfreeze()
                                                                                               end)
                                     end 
                                                        end)
end

function map:on_opening_transition_finished()

end

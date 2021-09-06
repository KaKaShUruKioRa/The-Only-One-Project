local map = ...
local game = map:get_game()
local RNGdrop = require("data/scripts/algo/random_destructible") 

--------------------------------------------------------------------
--------------------------------------------------------------------

 RNGdrop:enemies()
 RNGdrop:destructibles()


--------------------------------------------------------------
--------------------------------------------------------------
function map:on_started()
    if game:get_value("Bosses_defeated") then
      map:set_entities_enabled("Armos_Boss_", false)
      BossFight_sensor:set_enabled(false)
    else
      for Bosses in map:get_entities("Armos_Boss_") do 
         Bosses:get_sprite():set_animation("stopped")
         Bosses:set_invincible()
         Bosses:set_can_attack(false)
         Bosses:stop_movement()
      end
     end
end

--------------------------------------------------------------------------------------

function BossFight_sensor:on_activated()
  hero:freeze()
    sol.timer.start(3500, function()
                            sol.audio.play_music("boss")

                            BossFight_sensor:set_enabled(false)
                          end)
    sol.timer.start(4500, function()    
                              for Bosses in map:get_entities("Armos_Boss_") do
                                  local SpriteBoss = Bosses:get_sprite()
                                  Bosses:set_default_attack_consequences()
                                  Bosses:set_attack_consequence("arrow", 30)
                                  Bosses:set_can_attack(true)
                                  SpriteBoss:set_animation("shaking")
                                  sol.audio.play_sound("enemy_awake")
                                    function SpriteBoss:on_animation_finished()
                                      Bosses:restart() 
                                      hero:unfreeze()
                                    end     
                              end
                            end)
end

--------------------------------------------------------------
------------------------------------------------------

function map:on_opening_transition_finished()

end
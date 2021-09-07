
local map = ...
local game = map:get_game()
local camera = map:get_camera()

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

local posX, posY, posL = 0, 0, 0


--------------------------------------------------------------------------------------

for Bosses in map:get_entities("Armos_Boss_") do
  function Bosses:on_dead()
    if map:get_entities_count("Armos_Boss_") == 1 then
          map:remove_entities("Armos_Boss_")
     end
    end
  end

-------------------------------------------------------------------------------------

for Bosses in map:get_entities("Armos_Boss_") do
  function Bosses:on_removed()
      if map:get_entities_count("Armos_Boss_") == 1 and not game:get_value("Bosses_defeated") then
              local properties = {name = "Armos_Boss_Red", x = 0, y = 0, layer = 0, breed = "bosses/armos_knight_red"}
              self:create_enemy(properties)
                  for Bosses in map:get_entities("Armos_Boss_Red") do
                    function Bosses:on_dead()
                      game:set_value("Bosses_defeated", true)
                      sol.audio.play_music("victory")
                      hero:set_direction(3)
                      hero:freeze()
                    sol.timer.start(3000, function()
                                    Boss_B1_SDoor:open()
                                    hero:start_victory(function()
                                                          local posX, posY, posL = Bosses:get_position()
                                                           if posX < 8 or posY < 8 then
                                                            camera:start_tracking(BossFight_sensor)
                                                            sol.audio.play_sound("heart_container")
                                                            Container_Boss_Dead:set_enabled(true)
                                                            Container_Boss_Dead:set_position(BossFight_sensor:get_center_position())
                                                           else
                                                             camera:start_tracking(Bosses)
                                                             sol.audio.play_sound("heart_container")
                                                             Container_Boss_Dead:set_enabled(true)
                                                             Container_Boss_Dead:set_position(posX, posY, posL) 
                                                           end
                                                       end)
                                    local timer_count = 0
                                      for BigDoors in map:get_entities("BigDoor_Boss_") do
                                          sol.timer.start(2500, function()
                                                                camera:start_tracking(camera_capt)
                                                                 local pos = BigDoors:get_position()
                                                                    if BigDoors:get_name() == "BigDoor_Boss_g" and timer_count < 4 then
                                                                       sol.audio.play_sound("enemy_awake")
                                                                       BigDoors:set_position(pos - 8, 16, 0)
                                                                       timer_count = timer_count + 1
                                                                       return true
                                                                    elseif BigDoors:get_name() == "BigDoor_Boss_d" and timer_count < 4 then
                                                                      sol.audio.play_sound("enemy_awake")
                                                                      BigDoors:set_position(pos + 8, 16, 0)
                                                                      timer_count = timer_count + 1
                                                                      return true
                                                                    else
                                                                      Mur_Nord:set_position(304, 0, 1)
                                                                      Top_BigDoor_Boss:set_position(304, 16 , 1)
                                                                      camera:start_tracking(hero)
                                                                      hero:unfreeze()
                                                                      return false
                                                                    end
                                                                  end)
                                       end
                                    end)
                    end
                 end
        end
    end  
end
--------------------------------------------------------------------------------------

function map:on_started()
  Boss_B1_SDoor:open()
  camera:get_position()
    if game:get_value("Bosses_defeated") then
      map:set_entities_enabled("Armos_Boss_", false)
      BigDoor_Boss_g:set_position(296 - 16, 16, 0 )
      BigDoor_Boss_d:set_position(320 + 16, 16, 0)
      Mur_Nord:set_position(304, 0, 1)
      Top_BigDoor_Boss:set_position(304, 16 , 1)
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
  hero:set_direction(3)
  hero:freeze()
    sol.timer.start(2500, function()
                            sol.audio.play_music("boss")
                            hero:unfreeze()
                            Boss_B1_SDoor:close()
                            BossFight_sensor:set_enabled(false)
                          end)
    sol.timer.start(3500, function()    
                              for Bosses in map:get_entities("Armos_Boss_") do
                                  local SpriteBoss = Bosses:get_sprite()
                                  Bosses:set_default_attack_consequences()
                                  Bosses:set_attack_consequence("arrow", 3)
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



--------------------------------------------------------------------------------------

function map:on_opening_transition_finished()

end
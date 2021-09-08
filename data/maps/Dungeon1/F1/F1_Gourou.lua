
local map = ...
local game = map:get_game()

----------------------------------------------------------
----------------------------------------------------------

---

local function sensor_detect_gourou()  
sol.timer.start(1000, function()    
                         if Gourou then
                            if Sensor_Gourou_Left:overlaps(Gourou,containing) == true and Gourou then
                              game:set_value("GourouDeadLeft", true) -- Poule tombée à gauche
                            elseif Sensor_Gourou_Right:overlaps(Gourou,containing) == true and Gourou then
                              game:set_value("GourouDeadRight", true) -- Poule tombée à droite
                            else
                              return true      
                            end
                         else 
                          return false                                                  
                         end
                      end)
end

------------------------------------------------------------

local function GourouDoors_Closed()
hero:set_position(160, 188, 0)
FightBossSensor:set_enabled(false)
WallTraps_1:set_position(144, 216, 0)  
WallTraps_2:set_position(144, 200, 0)
  for GourouDoors in map:get_entities("GourouDoor_") do
     GourouDoors:bring_to_front()
     pos = GourouDoors:get_position()
       if GourouDoors:get_name() == "GourouDoor_1" then
         GourouDoors:set_position(pos + 16, 192, 0)
       elseif GourouDoors:get_name() == "GourouDoor_2" then
         GourouDoors:set_position(pos - 16, 192, 0)
       end
  end
end

----------------------------------------------------------

local function Boss_Sequence_Start()
    function FightBossSensor:on_activated()
             local timer_count = 0 
                 hero:freeze() 
                WallTraps_1:set_position(144, 216, 0)  
                WallTraps_2:set_position(144, 200, 0) 
                  for GourouDoors in map:get_entities("GourouDoor_") do
                   GourouDoors:bring_to_front()
                    sol.timer.start(1750, function()    
                                              local pos = GourouDoors:get_position()
                                               if GourouDoors:get_name() == "GourouDoor_1" and timer_count < 4 then
                                                 sol.audio.play_sound("enemy_awake")
                                                 GourouDoors:set_position(pos + 8, 192)
                                                 timer_count = timer_count + 1
                                                 return true
                                               elseif GourouDoors:get_name() == "GourouDoor_2" and timer_count < 4 then
                                                 sol.audio.play_sound("enemy_awake")
                                                 GourouDoors:set_position(pos - 8, 192)
                                                 timer_count = timer_count + 1
                                                  return true
                                               else
                                                 return false
                                               end
                                            end)
                end
            sol.timer.start(3500, function()
            sol.audio.play_music("boss")
            hero:unfreeze()
            Gourou:restart()
            map:set_entities_enabled("black_hole_medusatile_", false)
            map:set_entities_enabled("medusa_", true)
            FightBossSensor:set_enabled(false)
            sensor_detect_gourou()
                                      end)
    end
end

----------------------------------------------------------
----------------------------------------------------------

function map:on_started()
if not game:get_value("GourouDead") then
  Boss_Sequence_Start()
  function Gourou:on_dead()
    lightpoule:set_enabled(false)
    sol.audio.play_sound("enemy_awake")
    map:set_entities_enabled("starswitch_", true)
    map:set_entities_enabled("medusa_", true)
  end
Gourou:stop_movement()
  elseif game:get_value("GourouDead") and not game:get_value("GourouSwitch_actived") then
    GourouDoors_Closed()  
    lightpoule:set_enabled(false)
    FightBossSensor:set_enabled(false)
    map:set_entities_enabled("starswitch_", true)
    map:set_entities_enabled("black_hole_medusatile_", false)
    else
      GourouDoors_Closed()
      lightpoule:set_enabled(false)
      FightBossSensor:set_enabled(false)
      map:set_entities_enabled("starswitch_", false)
      map:set_entities_enabled("black_hole_", false)
      map:set_entities_enabled("black_hole_medusatile_", false)
      map:set_entities_enabled("down_hole_", true)
end
end

----------------------------------------------------------

function starswitch_sensor:on_activated()
  if game:get_value("GourouDead") then
  sol.audio.play_music("victory")
  hero:set_direction(3)
  hero:freeze()
    sol.timer.start(3000, function()
                          hero:start_victory(function()
                                              hero:set_walking_speed(32)
                                              hero:walk("666666", false, true)
                                            
              end)
          end)
  sol.timer.start(4750, function()
                         sol.audio.play_sound("explosion")
                         sol.audio.stop_music()
                         map:set_entities_enabled("starswitch_", false)
                         map:set_entities_enabled("black_hole_", false)
                         map:set_entities_enabled("black_hole_medusatile_", false)
                         map:set_entities_enabled("medusa_", false)
                         map:set_entities_enabled("down_hole_", true)
                         game:set_value("GourouSwitch_actived", true)
                       end)

  end
end

----------------------------------------------------------

function map:on_opening_transition_finished()

end
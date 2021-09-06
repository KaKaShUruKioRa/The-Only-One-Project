-- Armos Knight Red boss.

local enemy = ...
local map = enemy:get_map()
local hero = map:get_hero()
local mapsize_x, mapsize_y = map:get_size()
local center_map_x = mapsize_x / 2
local center_map_y = mapsize_y / 2
local unlock_count = 1

---------------------------------------------------------
---------------------------------------------------------

local function unlock()

end

---------------------------------------------------------
---------------------------------------------------------

function enemy:on_created()
   self:set_life(30)
   self:set_damage(3)
   self:create_sprite("enemies/" .. enemy:get_breed())
   self:set_hurt_style("boss")
   self:set_pushed_back_when_hurt(true)
   self:set_size(16, 16)
   self:set_origin(8, 13)
   self:set_attack_consequence("sword", 2)
   self:set_attack_consequence("arrow", 3)
   self:set_attack_consequence("hookshot", 2)
end

---------------------------------------------------------

function enemy:on_restarted()
   jpmov = sol.movement.create("jump")
   jpmov:set_direction8(hero:get_direction8_to(enemy))
   jpmov:set_speed(40)
   jpmov:set_distance(math.random(5) * 16)
   jpmov:start(enemy, 
      function() 
        sol.audio.play_sound("lightning")
         chargehero = sol.movement.create("straight")
         chargehero:set_speed(400)
         chargehero:set_max_distance(64 + (math.random(6) * 16))
         chargehero:set_angle(enemy:get_angle(hero))
         chargehero:set_smooth(false)
         chargehero:start(enemy, 
          function() 
            cmov = sol.movement.create("circle")
            cmov:set_center(hero:get_position())
            cmov:set_radius(enemy:get_distance(hero))
            cmov:set_angle_from_center(hero:get_angle(enemy))
            cmov:set_angular_speed(math.random(2))
            cmov:set_max_rotations(math.random(4))
            cmov:start(enemy, 
              function()
                enemy:restart() 
              end)
                  function cmov:on_obstacle_reached()
                     str_mov = sol.movement.create("straight") 
                     str_mov:set_angle(enemy:get_angle(center_map_x + (math.random(8) * 12), center_map_y + (math.random(8) * 12)))
                     str_mov:set_speed(150)
                     str_mov:set_max_distance((math.random(8) * 8) + (unlock_count * 2))
                     str_mov:set_ignore_obstacles(true)
                     str_mov:start(enemy, 
                       function() 
                         unlock_count = unlock_count + 1 
                         enemy:restart() 
                       end) 
                  end
          end)
                function chargehero:on_obstacle_reached()
                      local timer_count = 1
                      sol.audio.play_sound("explosion")
                      enemy:stop_movement()
                      enemy:get_sprite():set_animation("immobilized")
                      sol.timer.start(750, 
                        function() 
                           sol.audio.play_sound("jump") 
                          if timer_count <= 4 then
                             timer_count = timer_count + 1
                             return true
                          else
                              str_mov = sol.movement.create("straight") 
                              str_mov:set_angle(enemy:get_angle(center_map_x + (math.random(8) * 12), center_map_y + (math.random(8) * 12)))
                              str_mov:set_speed(150)
                              str_mov:set_max_distance((math.random(8) * 8) + (unlock_count * 2))
                              str_mov:set_ignore_obstacles(true)
                              str_mov:start(enemy, function() unlock_count = unlock_count + 1 enemy:restart() end) 
                               return false
                            end
                          end)                
                end

      end)
end

---------------------------------------------------------

function enemy:on_dying()
  sol.audio.play_sound("lightning")
  local chargehero = sol.movement.create("straight")
  chargehero:set_ignore_obstacles(true)
  chargehero:set_speed(600)
  chargehero:set_max_distance(math.random(60) + 60)
  chargehero:set_angle(enemy:get_angle(hero))
  chargehero:start(enemy, function() 
                    if enemy:get_distance(hero) <= 60 then
                      hero:start_hurt(enemy, 3)
                    else
                    end
                          end)
end

---------------------------------------------------------
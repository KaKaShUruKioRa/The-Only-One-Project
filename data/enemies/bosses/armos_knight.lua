-- Armos Knight boss.

local enemy = ...
local map = enemy:get_map()
local hero = map:get_hero()
local mapsize_x, mapsize_y = map:get_size()
local center_map_x = (mapsize_x / 2) - 100
local center_map_y = (mapsize_y / 2) - 100
local unlock_count = 1
local jpmov = sol.movement.create("jump")
local chargehero = sol.movement.create("straight")
local str_mov = sol.movement.create("straight")
local cmov = sol.movement.create("circle")

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

function enemy:on_created()
  self:set_life(12)
  self:set_damage(1)
  self:create_sprite("enemies/" .. enemy:get_breed())
  self:set_hurt_style("boss")
  self:set_pushed_back_when_hurt(true)
  self:set_size(16, 16)
  self:set_origin(8, 13)
  self:set_attack_consequence("sword", 1)
  self:set_attack_consequence("arrow", 3)
  self:set_attack_consequence("hookshot", 1)
end

------------------------------------------------------------------------------------------------------------------

function enemy:on_restarted()
   jpmov = sol.movement.create("jump")
   jpmov:set_direction8(hero:get_direction8_to(enemy))
   jpmov:set_speed(67)
   jpmov:set_distance(math.random(4) * 16)
   jpmov:start(enemy, 
      function() 
        sol.audio.play_sound("lightning")
         chargehero = sol.movement.create("straight")
         chargehero:set_speed(250)
         chargehero:set_max_distance(64 + (math.random(4) * 16))
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
                     str_mov:set_speed(120)
                     str_mov:set_max_distance(16 + (unlock_count * 2))
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
                      sol.timer.start(1000, 
                        function() 
                           sol.audio.play_sound("jump") 
                          if timer_count <= 4 then
                             timer_count = timer_count + 1
                             return true
                          else
                              str_mov = sol.movement.create("straight") 
                              str_mov:set_angle(enemy:get_angle(center_map_x + (math.random(8) * 12), center_map_y + (math.random(8) * 12)))
                              str_mov:set_speed(120)
                              str_mov:set_max_distance(16 + (unlock_count * 2))
                              str_mov:set_ignore_obstacles(true)
                              str_mov:start(enemy, function() unlock_count = unlock_count + 1 enemy:restart() end) 
                               return false
                            end
                          end)                
                end

      end)
end



------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

function enemy:on_dying()
  sol.audio.play_sound("lightning")
  chargehero = sol.movement.create("straight")
  chargehero:set_ignore_obstacles(true)
  chargehero:set_speed(300)
  chargehero:set_max_distance(math.random(60) + 40)
  chargehero:set_angle(enemy:get_angle(hero))
  chargehero:start(enemy, function()
                    if self:get_distance(hero) <= 40 then
                      hero:start_hurt(enemy, 1)
                    else
                    end
                          end)
end

------------------------------------------------------------------------------------------------------------------
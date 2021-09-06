local map = ...
local game = map:get_game()

------------------------------------------------------------
------------------------------------------------------------

---------------------------------------------------------------------
---------------------------------------------------------------------

  --local life = {1, 2, 3}
  local life = 1
  --local speed = {40, 60, 80}
  local speed = 40

  local function stupid_soldiers_movement(enemies)
    local movement = sol.movement.create("path")
    movement:set_path{0,0,0,0,0,0,0,0,0,4,4,4,4,4,4,4,4,4}
    movement:set_speed(speed)
    movement:set_loop(true)
    movement:start(enemies)
  end

  local function enemies_get_properties(enemies)
    enemies:set_life(life) 
    enemies:set_damage(0)
    enemies:set_pushed_back_when_hurt(false)
    enemies:set_attack_consequence("arrow", 1)
    enemies:set_pushed_back_when_hurt(false)
    function enemies:on_restarted()
    enemies.movement = stupid_soldiers_movement(enemies)
    end
  end
------------------------------------------------------------
------------------------------------------------------------

function map:on_started()
  if game:get_value("mini_game_victory") then
    map:set_entities_enabled("soldier_target_", false)
    map:set_entities_enabled("open_acces_", true)
  else
  end
if game:get_value("To_Fairies_Activated") then
    if game:get_value("To_Fairies_Activated") == 1 then
        sol.timer.start(611, function() 
                      hero:freeze() 
                      sol.audio.play_sound("hero_lands") 
                         end)
    sol.timer.start(2500, function() 
                    sol.audio.play_sound("stone")
                    map:set_entities_enabled("To_Fairies_", true)   
                    hero:unfreeze()
                    game:set_value("To_Fairies_Activated", 2)
                           end)
    elseif game:get_value("To_Fairies_Activated") > 1 then
      map:set_entities_enabled("To_Fairies_", true)
    end
  end
end

------------------------------------------------------------
------------------------------------------------------------

    for enemies in map:get_entities("soldier_target_") do
      enemies.movement = stupid_soldiers_movement(enemies)
      enemies.properties = enemies_get_properties(enemies)
        function enemies:on_dead()
           if map:get_entities_count("soldier_target_") == 0 then
              map:set_entities_enabled("open_acces_", true)
              sol.audio.play_sound("door_unlocked")
              sol.audio.play_sound("door_closed")
              game:set_value("mini_game_victory", true)
           end
        end
    end

function map:on_opening_transition_finished()
  
end
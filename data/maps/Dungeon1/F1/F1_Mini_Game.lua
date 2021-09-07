local map = ...
local game = map:get_game()

------------------------------------------------------------
------------------------------------------------------------

---------------------------------------------------------------------
---------------------------------------------------------------------

  local life = {1, 2, 3}
  local speed = {40, 60, 80}

  local function stupid_soldiers_movement(enemies)
    local movement = sol.movement.create("path")
    movement:set_path{0,0,0,0,0,0,0,0,0,4,4,4,4,4,4,4,4,4}

    if string.find(enemies:get_name(), "back", 14) then
      movement:set_speed(speed[1])
    end  
  
    if string.find(enemies:get_name(), "mid", 14) then
       movement:set_speed(speed[2])
    end

    if string.find(enemies:get_name(), "front", 14) then
       movement:set_speed(speed[3])
    end    

    movement:set_loop(true)
    movement:start(enemies)
  end


  local function enemies_get_properties(enemies)
    if string.find(enemies:get_name(), "back", 14) then
      enemies:set_life(life[1])
    end

    if string.find(enemies:get_name(), "mid", 14) then
       enemies:set_life(life[2])
    end

    if string.find(enemies:get_name(), "front", 14) then
       enemies:set_life(life[3])   
    end

    enemies:set_damage(0)
    enemies:set_pushed_back_when_hurt(false)
    enemies:set_attack_consequence("arrow", 1)
    enemies:set_treasure()
    enemies:set_pushed_back_when_hurt(false)
    function enemies:on_restarted()
    enemies.movement = stupid_soldiers_movement(enemies)
    end
  end
------------------------------------------------------------
------------------------------------------------------------
function hero:on_obstacle_reached(movement)
    local hero_pos = {hero:get_position()} --récupère une table de 2 valeurs {x, y} position du héros
    local open_acces = {open_acces_3:get_position()} --récupère une table de 2 valeurs les {x, y}  position de la p'tite barrière
    if hero_pos[1] >= open_acces[1]-6 and hero_pos[1] <= (open_acces[1] + 96) then
      if hero_pos[2] >= open_acces[2]-2 and hero_pos[2] <= (open_acces[2] + 16) then
        hero:start_jumping(2, 6, true) -- débloque le héro en le faisant jump en haut de 6px
      end
    end 
    local open_acces = {open_acces_1:get_position()} --récupère une table de 2 valeurs les {x, y}  position de la p'tite barrière
    if hero_pos[1] >= open_acces[1]+6 and hero_pos[1] <= (open_acces[1] + 96) then
      if hero_pos[2] >= open_acces[2]+2 and hero_pos[2] <= (open_acces[2] + 16) then
        hero:start_jumping(2, 6, true) -- débloque le héro en le faisant jump en haut de 6px
      end
    end
end

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

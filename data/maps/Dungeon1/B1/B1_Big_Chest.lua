
local map = ...
local game = map:get_game()
 
    local hero_pos = {hero:get_position()} --récupère une table de 2 valeurs {x, y} position du héros
    local blockin_barrier = {blockin_barrier:get_position()} --récupère une table de 2 valeurs les {x, y}  position de la p'tite barrière

  function unlocker_bigchest:on_activated()
    hero_pos = {hero:get_position()} --récupère une table de 2 valeurs {x, y} position du héros
    if hero_pos[1] >= blockin_barrier[1]-6 and hero_pos[1] <= (blockin_barrier[1] + 56) then --collision check hero contre barrière (x)
      if hero_pos[2] >= blockin_barrier[2]-2 and hero_pos[2] <= (blockin_barrier[2] + 16 ) then --collision check hero contre barrière (y)
        hero:start_jumping(3, 6, true) -- débloque le héro en le faisant jump en diagonale haut-gauche de 6px
      end
    end 
end

function map:on_started()
  hide_ent_stair:set_enabled(false)
    if game:get_value("hide_ent_enabled") then
      map:set_entities_enabled("hide_ent_", true)
      switch_droite_souschef:set_activated()
    end
end


function map:on_opening_transition_finished()

end


function switch_droite_souschef:on_activated()
  sol.audio.play_sound("secret")
  hero:freeze()
  sol.timer.start(1500, function()
                      map:set_entities_enabled("hide_ent_", true)
                      game:set_value("hide_ent_enabled", true)
                      sol.audio.play_sound("explosion")
                      switch_droite_souschef:set_locked(true)
                      hero:unfreeze()
                    end)
end


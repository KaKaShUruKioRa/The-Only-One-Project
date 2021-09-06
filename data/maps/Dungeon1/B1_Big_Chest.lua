
local map = ...
local game = map:get_game()


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
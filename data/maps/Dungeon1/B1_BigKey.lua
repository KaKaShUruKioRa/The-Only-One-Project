local map = ...
local game = map:get_game()


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function map:on_started()
  if game:get_value("GourouSwitch_actived") then
    map:set_entities_enabled("decor_fall_",true)
    open_barrier:set_enabled(true)
      if BigKey_Dun1 then
        BigKey_Dun1:set_enabled(true)
        hero:set_position(ontable:get_position())
        hero:set_walking_speed(88)
      end
      if game:get_value("GourouDeadLeft") then
        gouroudying_1:set_enabled(true)
      elseif game:get_value("GourouDeadRight") then
        gouroudying_2:set_enabled(true)
      end
       if game:get_value("BarrierOpened") then
          openbarrier:set_enabled(false)
          open_barrier:set_enabled(false)
       end
   end
end

-------------------------------------------------------------------------------

function open_barrier:on_activated()
  openbarrier:set_enabled(false)
  sol.audio.play_sound("door_open")
  open_barrier:set_enabled(false)
  game:set_value("BarrierOpened", true)
end

-------------------------------------------------------------------------------



-------------------------------------------------------------------------------

function map:on_opening_transition_finished()

end



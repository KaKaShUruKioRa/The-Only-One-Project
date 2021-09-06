local map = ...
local game = map:get_game()


function map:on_started()
  if game:get_value("Sewer_Wwall_Exploded") then
    B1_Entrance_SWwall_Wall:set_enabled(false)
    B1_Entrance_SWwall_TopDoor:set_enabled(true)
  end
  if game:get_value("Lantern_Obtained")then
    Entrance_B1_WDoor:set_enabled(false)
  end
end

function B1_Entrance_SWwall:on_opened()
  sol.audio.play_sound("secret")
  B1_Entrance_SWwall_Wall:set_enabled(false)
  B1_Entrance_SWwall_TopDoor:set_enabled(true)
end


function map:on_opening_transition_finished()

end
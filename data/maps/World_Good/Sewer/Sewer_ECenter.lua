local map = ...
local game = map:get_game()

------------------------------------------------------------
------------------------------------------------------------

function map:on_started()
  if game:get_value("Sewer_ECenter_Wwall_Explosed") then
    Sewer_ECenter_Wwall_Wall:set_enabled(false)
    Sewer_ECenter_Wwall_Bord:set_enabled(false)
    Sewer_ECenter_Wwall_TopDoor:set_enabled(true)
  end
end

------------------------------------------------------------

function Sewer_ECenter_Wwall:on_opened()
  sol.audio.play_sound("secret")
  Sewer_ECenter_Wwall_Wall:set_enabled(false)
  Sewer_ECenter_Wwall_Bord:set_enabled(false)
  Sewer_ECenter_Wwall_TopDoor:set_enabled(true)
end

------------------------------------------------------------

function map:on_opening_transition_finished()
end


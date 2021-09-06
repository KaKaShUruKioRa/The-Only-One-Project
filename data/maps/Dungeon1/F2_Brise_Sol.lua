local map = ...
local game = map:get_game()

----------------------------------------------------
----------------------------------------------------


local function Detect()
     if Capt_Stone:overlaps(Stone_1,containing) and Capt_Stone:overlaps(Stone_2,containing) and Capt_Stone:overlaps(Stone_3,containing) and Capt_Stone:overlaps(Stone_4,containing) then
     game:set_value("Floor_Destroyed", true)
     Sol_Fragile:set_enabled(false)
     map:set_entities_enabled("Capt_Stone_", false)
     map:set_entities_enabled("Stone_", false)
     map:set_entities_enabled("Trou_", true)
     sol.audio.play_sound("victory")
  else
  end
end

----------------------------------------------------
----------------------------------------------------

function map:on_started()
  if game:get_value("Floor_Destroyed") then
    Sol_Fragile:set_enabled(false)
    map:set_entities_enabled("Capt_Stone_", false)
    map:set_entities_enabled("Stone_", false)
    map:set_entities_enabled("Trou_", true)
  else
    F2_BriseSol_WDoor:set_enabled(false)
  end
  if game:get_value("freedom") then
   Close_WDoor:set_enabled(false)
  else
    for Closers in map:get_entities("Closer_capt_") do
     function Closers:on_activated()
       F2_BriseSol_WDoor:set_enabled(true)
       sol.audio.play_sound("door_closed")
       map:set_entities_enabled("Closer_capt_", false)
     end
    end
  end
end


for Stones in map:get_entities("Stone_") do
    function Stones:on_moved()
    Detect()
end
end
----------------------------------------------------

function map:on_opening_transition_finished()

end


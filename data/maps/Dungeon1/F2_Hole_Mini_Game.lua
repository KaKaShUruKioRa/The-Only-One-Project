local map = ...
local game = map:get_game()
local RNGdrop = require("scripts/algo/random_destructible") 

--------------------------------------------------------------------
--------------------------------------------------------------------

 RNGdrop:enemies()
 RNGdrop:destructibles()

--------------------------------------------------------------------
--------------------------------------------------------------------

function map:on_started()
  if not game:get_value("To_Fairies_Activated") then
    function To_Fairies_Capt:on_activated()
      game:set_value("To_Fairies_Activated", 1)
    end
  else Fairies_Dest:set_enabled(true)
  end
end

--------------------------------------------------------------------

function map:on_opening_transition_finished()

end

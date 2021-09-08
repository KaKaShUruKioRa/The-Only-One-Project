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
  if game:get_value("heart_hit_completed") then
     switch_heart:set_enabled(false)
     heart_hit_chest:set_enabled(true)
     switch_heart:set_enabled(false)
  end 
end

function switch_heart:on_activated()
  map:set_entities_enabled("hit_the_heart_", true)
end

function switch_heart:on_left()
   map:set_entities_enabled("hit_the_heart_", false)
end

function hit_the_heart_2:on_activated()
  hero:freeze()
  heart_hit_chest:set_enabled(true)
  sol.audio.play_sound("chest_appears")
  switch_heart:set_enabled(false)
  sol.timer.start(750, function() 
                           map:set_entities_enabled("hit_the_heart_", false)
                           hero:unfreeze()
                        end)
  game:set_value("heart_hit_completed", true)
end



function arrow_switch_door:on_activated()
  holes_B1_door:open()
end

function map:on_opening_transition_finished()

end

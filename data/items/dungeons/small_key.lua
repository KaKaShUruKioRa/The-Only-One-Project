local item = ...
local game = item:get_game()

function item:on_created()
  self:set_shadow("small")
  self:set_can_disappear(false)
  self:set_brandish_when_picked(false)
  self:set_assignable(false)
  self:set_sound_when_picked("picked_small_key")
  self:set_savegame_variable("small_key")
  self:set_amount_savegame_variable("amount_small_key")

end   

function item:on_started()
end

function item:on_obtaining(variant, savegame_variable)

self:add_amount(1)

end

function item:on_using()
end
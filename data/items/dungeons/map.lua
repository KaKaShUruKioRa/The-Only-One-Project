local item = ...
local game = item:get_game()

function item:on_created()
  self:set_can_disappear(false)
  self:set_brandish_when_picked(true)
  self:set_savegame_variable("possession_map")
  self:set_assignable(false)
end

function item:on_started()

end

function item:on_variant_changed(variant)

end
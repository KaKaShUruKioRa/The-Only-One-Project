local item = ...
local game = item:get_game()

function item:on_created()
  self:set_can_disappear(true)
  self:set_brandish_when_picked(false)
end

function item:on_started()
  item:set_obtainable(game:has_item("equipment/bow_quiver"))
end

function item:on_obtaining(variant, savegame_variable)
  local amounts = {1, 5, 10}
  local amount = amounts[variant]
  if amount == nil then
    error("Invalid variant '" .. variant .. "' for item 'arrow'")
  else
    game:get_item("equipment/bow_quiver"):add_amount(amount)
  end
end


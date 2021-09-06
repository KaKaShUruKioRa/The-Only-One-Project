local item = ...
local game = item:get_game()

-- Event called when the game is initialized.
function item:on_created()

  self:set_shadow("small")
  self:set_can_disappear(false)
  self:set_brandish_when_picked(true)
  self:set_savegame_variable("piece_of_heart")
  self:set_amount_savegame_variable("amount_piece_of_heart")
end

-- Event called when the hero is using this item.
function item:on_using()

  -- Define here what happens when using this item
  -- and call item:set_finished() to release the hero when you have finished.
  item:set_finished()
end

-- Event called when a pickable treasure representing this item
-- is created on the map.
function item:on_pickable_created(pickable)

  -- You can set a particular movement here if you don't like the default one.
end

function item:on_obtaining(variant, savegame_variable)
    self:add_amount(1)
    game:set_life(40)

  if self:get_amount() == 4 then
    self:set_amount(0)
    self:get_game():add_max_life(2)
    game:set_life(game:get_max_life())
  end

end
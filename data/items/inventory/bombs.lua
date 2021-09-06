-- This item represent the equipable bombs in the inventory, its settings
-- are made by the equipment/bomb_bag item

local item = ...
local game = item:get_game()

local sound_timer

function item:on_obtaining(variant, savegame_variable)
  -- Obtaining the Bow automatically gives a quiver
  local bomb_bag = game:get_item("equipment/bomb_bag")
  if not bomb_bag:has_variant() then
    bomb_bag:set_variant(1)
    -- We fills the quiver because on_obtaining is not called
    bomb_bag:set_amount(bomb_bag:get_max_amount())
  end
end

function item:on_created()
  item:set_savegame_variable("possession_bombs")
  item:set_assignable(true)
end

-- Called when the player uses the bombs of his inventory
function item:on_using()
  local bomb_bag = game:get_item("equipment/bomb_bag")
  if bomb_bag:get_amount() == 0 then
    if sound_timer == nil then
      sol.audio.play_sound("wrong")
      sound_timer = sol.timer.start(game, 500, function()
      sound_timer = nil
      end)
    end
  else
    bomb_bag:remove_amount(1)
    local x, y, layer = item:create_bomb()
    sol.audio.play_sound("bomb")
  end
  item:set_finished()
end

function item:create_bomb()
  local map = item:get_map()
  local hero = map:get_entity("hero")
  local x, y, layer = hero:get_position()
  local direction = hero:get_direction()
  if direction == 0 then
    x = x + 16
  elseif direction == 1 then
    y = y - 16
  elseif direction == 2 then
    x = x - 16
  elseif direction == 3 then
    y = y + 16
  end

    local bomb = map:create_bomb{
    x = x,
    y = y,
    layer = layer
  }
end
-- Script of the lantern.
local item = ...
local game = item:get_game()

local magic_needed = 2  -- Number of magic points required.

function item:on_created()
  item:set_savegame_variable("possession_lantern")
  item:set_assignable(true)
end

-- Called when the player obtains the lantern.
function item:on_obtained(variant, savegame_variable)

  -- Give the magic bar if necessary.
  local magic_meter = game:get_item("equipment/magic_meter")
  if not magic_meter:has_variant() then
    magic_meter:set_variant(1)
  end
end

-- Called when the hero uses the lantern.
function item:on_using()
  if game:get_magic() >= magic_needed then
    sol.audio.play_sound("lantern")
    game:remove_magic(magic_needed)
    item:create_fire()
  else
    -- TODO : Prevent spamming the sound
    sol.audio.play_sound("wrong")
  end
  item:set_finished()
end

-- Creates some fire on the map.
function item:create_fire()

  local map = item:get_map()
  local hero = map:get_hero()
  local direction = hero:get_direction()
  local dx, dy
  if direction == 0 then
    dx, dy = 18, -4
  elseif direction == 1 then
    dx, dy = 0, -24
  elseif direction == 2 then
    dx, dy = -20, -4
  else
    dx, dy = 0, 16
  end

  local x, y, layer = hero:get_position()
  map:create_custom_entity{
    model = "fire",
    x = x + dx,
    y = y + dy,
    layer = layer,
    width = 16,
    height = 16,
    direction = 0,
  }
end

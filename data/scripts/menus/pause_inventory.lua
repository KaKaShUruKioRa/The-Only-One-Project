local inventory_manager = {}

local gui_designer = require("scripts/menus/lib/gui_designer")

local item_names = {
  -- Names of up to 20 items to show in the inventory.
  "bow",  -- Will be replaced by the silver one if the player has it.
  "boomerang",
  "hookshot",
  "bombs",
  -- TODO "mushroom", -- Will be replaced by the magic powder if player has it.
  -- TODO "magic powder",
  "fire_rod",
  "ice_rod",
  -- TODO "bombos_medallion",
  -- TODO "ether_medallion",
  -- TODO "quake_medallion",
  "lantern",
  "hammer",
  -- TODO "shovel", -- Will be replaced by the ocarina
  "ocarina",
  -- TODO "bug_catching_net",
  "bottle_1",
  "bottle_2",
  "bottle_3",
  "bottle_4",
  -- TODO "cane_of_somaria",
  -- TODO "cane_of_byrna",
  -- TODO "magic_cape",
  -- TODO "magic_mirror",
}

local dungeons_items_names = { "big_key", "compass", "map", "small_key",
}

local equipment_names = {
  "glove", "bomb_bag", "bow_quiver", "flippers", "book_of_mudora",
}

local quest_items_name = {
  "mushroom"
}

local items_num_columns = 5
local items_num_rows = math.ceil(#item_names / items_num_columns)

local items_img = sol.surface.create("entities/items.png")
local movement_speed = 800
local movement_distance = 160

-- Draw part of inventory containing the equipable items
local function create_item_widget(game)
  local widget = gui_designer:create(176, 144)
  widget:set_xy(16, 16 - movement_distance)
  widget:make_green_frame()
  local items_surface = widget:get_surface()

  -- Draw the items, if they are possessed, depending on their variant
  for i, item_name in ipairs(item_names) do    
    local variant = game:get_item("inventory/" .. item_name):get_variant() -- 0 = not possesed

    if variant > 0 then
      local column = (i - 1) % items_num_columns + 1
      local row = math.floor((i - 1) / items_num_columns + 1)
      -- Draw the sprite statically. This is okay as long as
      -- item sprites are not animated.
      -- If they become animated one day, they will have to be
      -- drawn at each frame instead (in on_draw()).
      local item_sprite = sol.sprite.create("menus/inventory/"..item_name)
      item_sprite:set_direction(variant - 1)
      item_sprite:set_xy(8 + column * 32 - 16, 13 + row * 32 - 16)
      item_sprite:draw(items_surface)
    end
  end
  return widget
end

local function create_item_describe_widget(game)
  local widget = gui_designer:create(112, 48)
  widget:set_xy(200, 16 - movement_distance)
  widget:make_green_frame()
  return widget
end

local function create_quest_widget(game)

  local widget = gui_designer:create(112, 88)
  widget:set_xy(200, 72 - movement_distance)
  widget:make_yellow_frame()
  
-- Draw part of inventory containing the Dungeons Items
local function create_dungeons_items_widget(game)
  local widget = gui_designer:create(176, 144)
  widget:set_xy(16, 16 - movement_distance)
  widget:make_green_frame()
  local dungeons_items_surface = widget:get_surface()

  -- Draw the items, if they are possessed, depending on their variant
  for i, dungeons_items_name in ipairs(item_names) do    
    local variant = game:get_item("dungeons/" .. dungeons_items_name):get_variant() -- 0 = not possesed

    if variant > 0 then
      local column = (i - 1) % items_num_columns + 1
      local row = math.floor((i - 1) / items_num_columns + 1)
      -- Draw the sprite statically. This is okay as long as
      -- item sprites are not animated.
      -- If they become animated one day, they will have to be
      -- drawn at each frame instead (in on_draw()).
      local item_sprite = sol.sprite.create("menus/dungeons/"..item_name)
      item_sprite:set_direction(variant - 1)
      item_sprite:set_xy(8 + column * 32 - 16, 13 + row * 32 - 16)
      item_sprite:draw(dungeons_items_surface)
    end
  end
  return widget
end

  -- TODO : draw quest items

  return widget

end

local function create_equipment_widget(game)

  local widget = gui_designer:create(112, 64)
  widget:set_xy(200, 168 - movement_distance)
  widget:make_yellow_frame()

  return widget

end

local function create_do_widget(game)

  local widget = gui_designer:create(176, 64)
  widget:set_xy(16, 168 - movement_distance)
  widget:make_red_frame()

  return widget

end

function inventory_manager:new(game)

  local inventory = {}

  local state = "opening"  -- "opening", "ready" or "closing".

  local item_widget = create_item_widget(game)
  local item_describe_widget = create_item_describe_widget(game)
  local quest_widget = create_quest_widget(game)
  local do_widget = create_do_widget(game)
  local equipment_widget = create_equipment_widget(game)

  local item_cursor_fixed_sprite = sol.sprite.create("menus/item_cursor")
  item_cursor_fixed_sprite:set_animation("solid_fixed")
  local item_cursor_moving_sprite = sol.sprite.create("menus/item_cursor")
  item_cursor_moving_sprite:set_animation("dashed_blinking")

  -- Determine the place of the item currently assigned if any.
  local item_assigned_row, item_assigned_column, item_assigned_index
  local item_assigned = game:get_item_assigned(1)
  if item_assigned ~= nil then
    local item_name_assigned = item_assigned:get_name()
    for i, item_name in ipairs(item_names) do

      if item_name == item_name_assigned then
        item_assigned_column = (i - 1) % items_num_columns
        item_assigned_row = math.floor((i - 1) / items_num_columns)
        item_assigned_index = i - 1
      end
    end
  end

  -- Rapidly moves the inventory widgets towards or away from the screen.
  local function move_widgets(callback)

    local angle_added = 0
    if select(2, item_widget:get_xy()) > 0 then
      -- Opposite direction when closing.
      angle_added = math.pi
    end

    local movement = sol.movement.create("straight")
    movement:set_speed(movement_speed)
    movement:set_max_distance(movement_distance)
    movement:set_angle(3 * math.pi / 2 + angle_added)
    item_widget:start_movement(movement, callback)

    local movement = sol.movement.create("straight")
    movement:set_speed(movement_speed)
    movement:set_max_distance(movement_distance)
    movement:set_angle(3 * math.pi / 2 + angle_added)
    item_describe_widget:start_movement(movement)

    local movement = sol.movement.create("straight")
    movement:set_speed(movement_speed)
    movement:set_max_distance(movement_distance)
    movement:set_angle(3 * math.pi / 2 + angle_added)
    quest_widget:start_movement(movement)

    local movement = sol.movement.create("straight")
    movement:set_speed(movement_speed)
    movement:set_max_distance(movement_distance)
    movement:set_angle(3 * math.pi / 2 + angle_added)
    do_widget:start_movement(movement)

    local movement = sol.movement.create("straight")
    movement:set_speed(movement_speed)
    movement:set_max_distance(movement_distance)
    movement:set_angle(3 * math.pi / 2 + angle_added)
    equipment_widget:start_movement(movement)

  end

  local cursor_index = game:get_value("pause_inventory_last_item_index") or 0
  local cursor_row = math.floor(cursor_index / items_num_columns)
  local cursor_column = cursor_index % items_num_columns

  -- Draws cursors on the selected and on the assigned items.
  local function draw_item_cursors(dst_surface)

    -- Selected item.
    local widget_x, widget_y = item_widget:get_xy()
    item_cursor_moving_sprite:draw(
        dst_surface,
        widget_x + 24 + 32 * cursor_column,
        widget_y + 24 + 32 * cursor_row
    )

    -- Item assigned (only if different from the selected one).
    if item_assigned_row ~= nil then
      if item_assigned_index ~= cursor_index then
        item_cursor_fixed_sprite:draw(
            dst_surface,
            widget_x + 24 + 32 * item_assigned_column,
            widget_y + 24 + 32 * item_assigned_row
        )
      end
    end
  end

  -- Changes the position of the item cursor.
  local function set_cursor_position(row, column)
    cursor_row = row
    cursor_column = column
    cursor_index = cursor_row * items_num_columns + cursor_column
    if cursor_index == item_assigned_index then
      item_cursor_moving_sprite:set_animation("solid_blinking")
      item_cursor_moving_sprite:set_frame(1)
    else
      item_cursor_moving_sprite:set_animation("dashed_blinking")
    end
  end

  function inventory:on_draw(dst_surface)

    item_widget:draw(dst_surface)
    item_describe_widget:draw(dst_surface)
    quest_widget:draw(dst_surface)
    do_widget:draw(dst_surface)
    equipment_widget:draw(dst_surface)

    -- Show the item cursors.
    draw_item_cursors(dst_surface)
  end

  function inventory:on_command_pressed(command)

    if state ~= "ready" then
      return true
    end

    local handled = false

    if command == "pause" then
      -- Close the pause menu.
      state = "closing"
      sol.audio.play_sound("pause_closed")
      move_widgets(function() game:set_paused(false) end)
      handled = true

    elseif command == "item_1" or command == "action" then
      -- Assign an item.
      local item = game:get_item("inventory/" .. item_names[cursor_index + 1])
      if cursor_index ~= item_assigned_index
          and item:has_variant()
          and item:is_assignable() then
        sol.audio.play_sound("ok")
        game:set_item_assigned(1, item)
        item_assigned_row, item_assigned_column = cursor_row, cursor_column
        item_assigned_index = cursor_row * items_num_rows + cursor_column
        item_cursor_moving_sprite:set_animation("solid_blinking")
        item_cursor_moving_sprite:set_frame(0)
      end
      handled = true

    elseif command == "right" then
      if cursor_column < items_num_columns - 1 then
        sol.audio.play_sound("cursor")
        set_cursor_position(cursor_row, cursor_column + 1)
        handled = true
      end

    elseif command == "up" then
      sol.audio.play_sound("cursor")
      if cursor_row > 0 then
        set_cursor_position(cursor_row - 1, cursor_column)
      else
        set_cursor_position(items_num_rows - 1, cursor_column)
      end
      handled = true

    elseif command == "left" then
      if cursor_column > 0 then
        sol.audio.play_sound("cursor")
        set_cursor_position(cursor_row, cursor_column - 1)
        handled = true
      end

    elseif command == "down" then
      sol.audio.play_sound("cursor")
      if cursor_row < items_num_rows - 1 then
        set_cursor_position(cursor_row + 1, cursor_column)
      else
        set_cursor_position(0, cursor_column)
      end
      handled = true
    end

    return handled
  end

  function inventory:on_finished()
    -- Store the cursor position.
    game:set_value("pause_inventory_last_item_index", cursor_index)
  end

  set_cursor_position(cursor_row, cursor_column)
  move_widgets(function() state = "ready" end)

  return inventory
end

return inventory_manager


-- The small_key counter shown in the HUD

local builder = {}

local icon_img = sol.surface.create("hud/small_key_icon.png")

function builder:new(game, config)
  local hud_small_key = {}

  local digits_text = sol.text_surface.create({
    font = "white_digits",
    horizontal_alignment = "left",
    vertical_alignment = "top",
  })
  local amount_displayed = game:get_item("dungeons/small_key"):get_amount()

  local dst_x, dst_y = config.x, config.y

  function hud_small_key:on_draw(dst_surface)

    local x, y = dst_x, dst_y
    local width, height = dst_surface:get_size()
    if x < 0 then
      x = width + x
    end
    if y < 0 then
      y = height + y
    end

    icon_img:draw(dst_surface, x + 8, y)
    digits_text:draw(dst_surface, x + 5, y + 10)
  end

  -- Checks whether the view displays correct information
  -- and updates it if necessary.
  local function check()

    local need_rebuild = false
    local amount = game:get_item("dungeons/small_key"):get_amount()
    local max_amount = game:get_item("dungeons/small_key"):get_max_amount()

    -- Current amount.
    if amount ~= amount_displayed then

      need_rebuild = true
      if amount_displayed < amount then
        amount_displayed = amount_displayed + 1
      else
        amount_displayed = amount_displayed - 1
      end

    end

    if digits_text:get_text() == "" then
      need_rebuild = true
    end

    -- Update the text if something has changed.
    if need_rebuild then
      digits_text:set_text(string.format("%02d", amount_displayed))

      -- Show in green if the maximum is reached.
      if amount_displayed == max_amount and max_amount ~= 0 then
        digits_text:set_font("green_digits")
      else
        digits_text:set_font("white_digits")
      end
    end

    return true  -- Repeat the timer.
  end

  -- Periodically check.
  check()
  sol.timer.start(game, 250, check)

  return hud_small_key
end

return builder


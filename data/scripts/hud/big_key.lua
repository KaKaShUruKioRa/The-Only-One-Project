-- The big_key shown in the HUD

local builder = {}

local icon_img = sol.surface.create("hud/big_key_icon.png")
local icon_img_not = sol.surface.create("hud/no_big_key_icon.png") 

function builder:new(game, config)
  local hud_big_key = {}

  local dst_x, dst_y = config.x, config.y

  -- Checks whether the view displays correct information
  -- and updates it if necessary.
  local function check()

    local need_rebuild = false
    local posseded = game:get_value("possession_big_key")

    -- if you posseded it.
    if posseded  then
      need_rebuild = true
       function hud_big_key:on_draw(dst_surface)
       local x, y = dst_x, dst_y
       local width, height = dst_surface:get_size()
          if x < 0 then
            x = width + x
          end
          if y < 0 then
            y = height + y
          end
        icon_img:draw(dst_surface, x + 8, y)
       end

    else
       function hud_big_key:on_draw(dst_surface)
       local x, y = dst_x, dst_y
       local width, height = dst_surface:get_size()
          if x < 0 then
            x = width + x
          end
          if y < 0 then
            y = height + y
          end
        icon_img_not:draw(dst_surface, x + 8, y)
       end
    end
   return true
  end


  -- Periodically check.
  check()
  sol.timer.start(game, 1000, check)

  return hud_big_key
end

return builder


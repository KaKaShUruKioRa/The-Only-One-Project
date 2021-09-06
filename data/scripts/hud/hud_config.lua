-- Defines the elements to put in the HUD
-- and their position on the game screen.

-- You can edit this file to add, remove or move some elements of the HUD.

-- Each HUD element script must provide a method new()
-- that creates the element as a menu.
-- See for example scripts/hud/hearts.lua.

-- Negative x or y coordinates mean to measure from the right or bottom
-- of the screen, respectively.

local hud_config = {

  -- Item assigned to slot 1. = NOP PAS DU TOUT !
  {
    menu_script = "scripts/hud/magic_meter",
    x = 294,
    y = 0,
    slot = 1,  -- Item slot (1 or 2).
  },

 
  --[[ Pause icon.
  {
    menu_script = "scripts/hud/pause_icon",
    x = 0,
    y = 6,
  },
--]]

  -- Item icon for slot 1.
  {
    menu_script = "scripts/hud/item_icon",
    x = 4,
    y = 4,
    slot = 1,  -- Item slot (1 or 2).
  },

  --[[ Item icon for slot 2.
  {
    menu_script = "scripts/hud/item_icon",
    x = 4,
    y = 4,
    slot = 2,  -- Item slot (1 or 2).
  },
--]]

  -- Attack icon.
  {
    menu_script = "scripts/hud/attack_icon",
    x = 4,
    y = 4,
  },

  -- Action icon.
  {
    menu_script = "scripts/hud/action_icon",
    x = 4,
    y = 28,
},

  -- Rupee counter.
  {
    menu_script = "scripts/hud/rupees",
    x = 4,
    y = 220,
  },

 -- Bombs counter
  {
    menu_script = "scripts/hud/bombs",
    x = 294,
    y = 220,
  },

 -- Arrow counter
  {
    menu_script = "scripts/hud/arrows",
    x = 274,
    y = 220,
  },

 -- Small Key counter
  {
    menu_script = "scripts/hud/small_key",
    x = 254,
    y = 220,
  },

 -- Big Key.
  {
    menu_script = "scripts/hud/big_key",
    x = 234,
    y = 220,
  },

  -- Hearts meter.
  {
    menu_script = "scripts/hud/hearts",
    x = -108,
    y = 0,
  },

  -- You can add more HUD elements here.
}

return hud_config

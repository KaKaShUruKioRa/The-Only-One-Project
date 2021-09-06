local enemy = ...

local behavior = require("enemies/library/soldier")

local properties = {
  main_sprite = "enemies/" .. enemy:get_breed(),
  sword_sprite = "enemies/" .. enemy:get_breed() .. "_weapon",
  life = 2,
  damage = 1,
  normal_speed = 64,
  faster_speed = 64,
}

behavior:create(enemy, properties)

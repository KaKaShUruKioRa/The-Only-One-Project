local enemy = ...

local behavior = require("enemies/library/soldier")

local properties = {
  main_sprite = "enemies/" .. enemy:get_breed(),
  sword_sprite = "enemies/" .. enemy:get_breed() .. "_weapon",
  life = 6,
  damage = 2,
  normal_speed = 80,
  faster_speed = 88,
}

behavior:create(enemy, properties)

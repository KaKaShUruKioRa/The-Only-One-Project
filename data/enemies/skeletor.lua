-- Lua script of enemy skeletor.
-- This script is executed every time an enemy with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest
local enemy = ...
local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local sprite
local movement

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function enemy:on_created()

  sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_life(10)
  enemy:set_damage(1)
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function enemy:on_restarted()
-- Event called when the enemy should start or restart its movements.
-- This is called for example after the enemy is created or after
-- it was hurt or immobilized.

  movement = sol.movement.create("target")
  movement:set_target(hero)
  movement:set_speed(48)
  movement:start(enemy)
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
 
function enemy:on_movement_changed()

sprite:set_direction(movement:get_direction4())

end 
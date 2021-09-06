-- Lua script of map hubcentral.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()


end

  for updownlayer in map:get_entities("updown_sensor") do

    function updownlayer:on_activated() -- Quand notre personnage passe dans un capteur prévu pour changer de couche
      hero:set_walking_speed(54) -- vitesse du perso réduite pour immiter une impression d'effort (vous pouvez l'enlever si vous ne souhaitez pas)
      herodir = hero:get_direction() -- on récupère la direction du perso
      local timer_count = 0 -- Variable qui servira pour vérifier si le perso s'est bloqué ou pas

        if herodir == 0 then herodir = "000" -- Comme la direction du héros à 4 position mais que la fonction walk en à 8 on traduit la direction
          elseif herodir == 1 then herodir = "222"
          elseif herodir == 2 then herodir = "444"
          elseif herodir == 3 then herodir = "666"
        end

      hero:walk(herodir,false, true) -- herodire sera le path de notre personnage, non bouclé, mais qui permet de traversé le décors le temps de l'animation walk
        if 
          hero:get_layer() == 0 then hero:set_layer(hero:get_layer() + 1) -- si notre perso était sur la couche 0 il va grimpé en couche 1 (selon les besoins,  modifiez)                               
        else 
          sol.timer.start(300, function() hero:set_layer(hero:get_layer() - 1) 
       -- si notre perso était en couche 1 il va descendre sur la couche 0 (le timer 300 évite que notre personnage soit vu en dessous du décors)
                                       end)
       end      
        sol.timer.start(500, function() -- ici on active un timer qui va se répété le temps de vrifié si le perso ne s'est pas bloqué              
             function hero:on_obstacle_reached() -- dans ce laps de temps (4x500ms) si le joueur rencontre un obstacle
               if timer_count <= 3 then -- le lapse de temps est défini par ce if. sinon la fonction reste active...
                 hero:set_position(updownlayer:get_position()) -- le perso est tp au dernier sensor traverser
                 local timer_count = 4 -- le joueur ayant usé du tp fournit par on_obstacle_reached() on désactive la fonction en quelque sorte
                                       -- et le sol.timer va recommencer puisqu'on est tp sur le dernier, sensor qui se réactive donc..
               else -- sinon si il le joueur ne se bloque pas, les 4 x 500ms passent et le timer+la fonction de tp est désactivé !
             end
             end
             timer_count = timer_count + 1
                              return timer_count <= 4 --arrête du timer jusqu'à une nouvelle traversé dans sensor.
                              end)
          hero:set_walking_speed(88) -- Retour à la vitesse normale du personnage
    end
end
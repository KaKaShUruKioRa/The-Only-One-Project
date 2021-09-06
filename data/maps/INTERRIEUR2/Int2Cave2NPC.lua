-- Lua script of map image.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

local fairy_img = sol.surface.create("menus/fairy_cursor.png")


-- Event called at initialization time, as soon as this map is loaded.

    function map:on_started() --crée un fonction au démaragge de la map
   
    local movement = sol.movement.create("random_path") --crée un objet nommée movement avec mouvement aléatoire
       movement:set_speed(32) --défini la vitesse du movement
       movement:start(MrShroom) --applique l'objet movement sur un personnage nommée
     
   
  -- You can initialize the movement and sprites of various
  -- map entities here.

    end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.

    function map:on_opening_transition_finished()

    end


-- Function called repeatedly at each cycle to redraw the screen
    function map:on_draw(dst_surface)

      fairy_img:draw(dst_surface, 304, 224)

    end



    function MrShroom:on_interaction()

      sol.audio.play_music("sanctuary")

        if game:get_value("mrshroomquest") then
           game:start_dialog("cave2.mrshroomquest", function()
                                                       hero:start_treasure("consumables/heart", 1)
                                                     end)
         else
           game:start_dialog("cave2.mrshroom1st",
                                function(answer)
                                   if answer == 3 then -- 3 = "J'n'ai pas qu'ça à faire"
                                        game:start_dialog("cave2.mrshroomno") -- Nouveau Dialogue de deception
                                   else -- Sinon, "Bien sur"
                                        game:start_dialog("cave2.mrshroomyes", 
                                                                function() -- Nouveau Dialogue de contentement et nouvelle fonction (sans réponse)
                                                                  hero:start_treasure("quest/mushroom", 1, "mrshroomquest", 
                                                                                                                function() 
                                                                                          --CallBack Function pour éviter la superposition du dialogue + l'animation _treasure
                                                                                                                game:start_dialog("cave2.paradoxshroom")
                                                                                           -- Vous recevez un Champignon... Mais n'en avait-il pas besoin ?
-- game:set_value("mrshroomquest", true) est inclue dans le hero:start_treasure dans le 3eme paramètre
                                                                                                                end)         
                                                                end)
                                   end
                               end)
         end
    end

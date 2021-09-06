-- Initialise des comportements globaux pour le jeu complet !

------------------------------------------------------------------
------------------------------------------------------------------
-- Déclare des variables ici
local quest_manager = {}


------------------------------------------------------------------
------------------------------------------------------------------
-- Déclare des méthodes ici 


local function send_hero(hero, from_sensor,to_sensor)

    local hero_x, hero_y = hero:get_position()
    local from_sensor_x, from_sensor_y = from_sensor:get_position()
    local to_sensor_x, to_sensor_y = to_sensor:get_position()

    hero_x = hero_x + (to_sensor_x - from_sensor_x)
    hero_y = hero_y + (to_sensor_y - from_sensor_y)
    hero:set_position(hero_x, hero_y)

end

--

local function initialize_sensor()
  local sensor_meta = sol.main.get_metatable("sensor")
  -- sensor_meta représente le comportement par défaut des sensors.
  function sensor_meta:on_activated()
  -- self is the sensor
    local name = self:get_name()
      if name:match("^capt_detect_tp_") then
        local map = self:get_map()
        local hero = map:get_hero()
          for index in string.gmatch(name, "%d") do -- récupère le chiffre(avec "%d" d pour digit(chiffre)) du capteur et l'insére dans la var index
             local dest_capt = map:get_entity("capt_detect_dest_"..index)
             send_hero(hero, self, dest_capt)
          end
      end
  end
end


--

local function initialize_destructible()
  local destructible_meta = sol.main.get_metatable("destructible")
  -- destructible_meta représente le comportement par défaut des destructibles.

  function destructible_meta:on_created()
  -- self is a destructible
     local sprite_name = self:get_sprite():get_animation_set()

        if not self:get_name() then

           if sprite_name:match("^destructibles/bush_") or sprite_name:match("^destructibles/grass_") then
              self:set_weight(-1)
              self:set_can_be_cut(true)
              self:set_destruction_sound("bush")
          elseif sprite_name:match("^destructibles/vase_") then
            self:set_weight(0)
            self:set_can_be_cut(false)
            self:set_destruction_sound("stone")
          elseif sprite_name:match("^destructibles/stone_") then
            for index in string.gmatch(sprite_name, "%d") do -- On récupère le chiffre dans le nom du sprite pour le mettre en index
              print(index)
              self:set_weight(index)
            end
                  self:set_can_be_cut(false)
                  self:set_destruction_sound("stone")
          end

      end
  end
-- TODO:affichez un dialogue quand le joueur tente de levé des buissons (hint: on_pressed(action) game/map)
--[[
         function destructible_meta:??
              if self:get_can_be_cut() and not self:get_can_explode() and self:get_weight() == -1 and not game:has_ability("sword") then
                
              game:start_dialog("on_looked.cant_cut")
--]]

       function destructible_meta:on_looked()
         local game = self:get_game() -- récupère la variable game
            if game:get_ability("lift") < 1 then
              game:start_dialog("on_looked.cant_lift")
            elseif self:get_weight() == 2 and  game:get_ability("lift") < 2 then
              game:start_dialog("on_looked.still_cant_lift")
            end
      end

end

------------------------------------------------------------------
------------------------------------------------------------------
-- Appelle des évènement ici

function quest_manager:initialize_quest()
  initialize_sensor()
  initialize_destructible()
end

------------------------------------------------------------------

return quest_manager --renvoie la table quest_manager pour require (si non renvoyé, require retourne un booléen)
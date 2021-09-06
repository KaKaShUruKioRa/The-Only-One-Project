local map = ...
local game = map:get_game()

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

    function map:on_started() --La map a démarré et execute les functions incluses dans cette functoin map:on_started()

        function EnfermeLeHero:on_activated()
           sol.audio.play_sound("enemy_awake")
            map:set_entities_enabled("piege",true) --ce fonction remplace les deux lignes du dessous, en vérifiant toutes les entités de la map ayant le nom "piege..."
           --piege1:set_enabled(true)
           --piege2:set_enabled(true)
           game:set_value("piegeactivated", 1)
        end

---------------------------------------------------------------------------------
      
            if game:get_value("enable_map_chest_dun1") then
                      --Si Coffre a été ouvert alors
              chest_switch:set_activated(true)
            else
              map_chest_dun1:set_enabled(false)
        -- Sinon le coffre reste caché et le bouton inactivé
            end

---------------------------------------------------------------------------------

            if game:get_value("piegeactivated") then
                      --Si le piège a été activé alors les piege sont activé
               map:set_entities_enabled("piege",true)
           end -- Sinon les pièges reste inactivé

    end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function map:on_opening_transition_finished() -- A la fin de la transition d'ouverture de la map
    
    function chest_switch:on_activated()
      sol.audio.play_sound("chest_appears")
      map_chest_dun1:set_enabled(true)
      game:set_value("enable_map_chest_dun1", 1)
    end

end

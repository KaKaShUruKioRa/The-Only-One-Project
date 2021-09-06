local map = ...
local game = map:get_game()

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function IndiceLie:on_interaction()
           game:start_dialog("Indices.IndiceQuestion", function(answer)
                                     if answer == 3 then -- 3 ligne de la box : Oui
                                        game:start_dialog("Indices.HelpLie") -- Afficher l'Indice lié à la plaque 
                                     else -- 4 ligne (ou autres) : Non / Ne rien faire.
                                     end 
                                                        end)           
   end

-------------------------------------------------------------------------------

function map:on_started()
  hide_ent_stair:set_enabled(false)
    if game:get_value("hide_ent_enabled") then
      map:set_entities_enabled("hide_ent_", true)
    end
end

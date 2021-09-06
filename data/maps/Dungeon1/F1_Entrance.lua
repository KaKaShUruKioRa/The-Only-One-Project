local map = ...
local game = map:get_game()
local RNGdrop = require("scripts/algo/random_destructible") 

-------------------------------------------------------------------------------
------------------------------------------------------------------------------- 

RNGdrop:enemies()
RNGdrop:destructibles()

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local function InteractionIndices(Indices)
           game:start_dialog("Indices.IndiceQuestion", function(answer)
                                     if answer == 3 and Indices:get_name() == "IndiceMaxLife" then -- 3 ligne de la box : Oui
                                        game:start_dialog("Indices.HelpMaxLife") -- Afficher l'Indice lié à la plaque 
                                     elseif answer == 3 and Indices:get_name() == "IndiceCondamned" then -- 3 ligne de la box : Oui
                                              game:start_dialog("Indices.HelpCondamned") -- Afficher l'Indice lié à la plaque 
                                     else -- 4 ligne (ou autres) : Non / Ne rien faire.
                                     end 
                                                        end)           
   end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function map:on_started()
  if game:get_value("Floor_Destroyed") then
      map:set_entities_enabled("hole_enter_", true)
  end
  if game:get_value("door_entre_h_2_opened") or game:get_value("door_entre_g_2_opened") then
    switch_door_gh:set_activated(true)
  end
end

-------------------------------------------------------------------------------

function switch_door_gh:on_activated()
  map:open_doors("door_entree_")
  sol.audio.play_sound("door_open")
end


-------------------------------------------------------------------------------

for Indices in map:get_entities("Indice") do
Indices.on_interaction = InteractionIndices
end

-------------------------------------------------------------------------------

function map:on_opening_transition_finished()
end
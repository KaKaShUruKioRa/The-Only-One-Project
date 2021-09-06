local map = ...
local game = map:get_game()

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local function sensor_reset()
    for Blocks in map:get_entities("block_") do
    for AntiBlocks in map:get_entities("AntiBlock_") do
      sol.timer.start(1500, function()
                              if AntiBlocks:overlaps(Blocks,containing) == true then
                                 Blocks:reset()
                                 return true
                              else
                                 return true
                              end 
                         
                          end)
   end
   end
end

-------------------------------------------------------------------------------

local function chestdoor_unlocked()
           hero:freeze()
           sol.audio.play_sound("chest_appears")
           enigmechest_cleenigme:set_enabled(true)
           sol.timer.start(1000,function()
                              pushblock_door:open()
                              map:remove_entities("AntiBlock_")
                              hero:unfreeze()   
                                end)
       game:set_value("enigmecompleted", true)
       end

-------------------------------------------------------------------------------

local function sensor_valid_triforce()
sol.timer.start(1000, function()    
                        if block_triforce:overlaps(blockcapt,containing) == true and switch_bousole_chest:is_activated() then
                          chestdoor_unlocked()
                          blockcapt:remove()
                          map:remove_entities("AntiBlock_")
                        else
                          return true 
                        end
                       end)
end

-------------------------------------------------------------------------------

  local function InteractionIndices(Indices)
           game:start_dialog("Indices.IndiceQuestion", function(answer)
                                        if answer == 3 and Indices:get_name() == "IndiceLocked" then -- 3 ligne de la box : Oui
                                          game:start_dialog("Indices.HelpLocked") -- Afficher l'Indice lié à la plaque 
                                        elseif answer == 3 and Indices:get_name() == "IndiceTriforce" then -- 3 ligne de la box : Oui
                                          game:start_dialog("Indices.HelpTriforce") -- Afficher l'Indice lié à la plaque 
                                        else -- 4 ligne (ou autres) : Non / Ne rien faire.
                                                  end 
                                        end)           
  end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function map:on_started()
pushblock_door:open()
  if not game:get_value("enigmecompleted") then 
    sensor_reset()
    sensor_valid_triforce()
   else
      -- TODO : A améliorer ! avec une boucle ou quelque chose du genre
      block_triforce:set_position(position_block_1:get_position())
      block_switch:set_position(position_block_2:get_position())
    --[[  for PositionBlocks in map:get_entities("position_block_") do
        for Blocks in map:get_entities("block_") do
          Blocks:set_position(PositionBlocks:get_position())
        end
      end
--]]
        map:remove_entities("AntiBlock_")
        blockcapt:remove()
        map:set_entities_enabled("enigmechest_", true)
        switch_bousole_chest:remove()
   end 
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function AntiBlock_6:on_activated()
pushblock_door:close()
end

-------------------------------------------------------------------------------
------------------------------------------------------------------------------- 

function switch_bousole_chest:on_activated()
  sol.audio.play_sound("chest_appears")
  enigmechest_rupees20:set_enabled(true)
end

-------------------------------------------------------------------------------
------------------------------------------------------------------------------- 


for Indices in map:get_entities("Indice") do
  Indices.on_interaction = InteractionIndices
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function map:on_opening_transition_finished()

end
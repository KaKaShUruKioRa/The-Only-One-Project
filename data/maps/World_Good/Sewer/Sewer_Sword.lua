local map = ...
local game = map:get_game()
local RNGdrop = require("scripts/algo/random_destructible") 

------------------------------------------------------------------------------
------------------------------------------------------------------------------

local timer_count = 1
local rupeedialoglu = 0
local no_sound = false

------------------------------------------------------------------------------
------------------------------------------------------------------------------


RNGdrop:enemies()
RNGdrop:destructibles()

------------------------------------------------------------------------------
------------------------------------------------------------------------------

local function definebarriers()
    for TBarriers in map:get_entities("Top_Barrier_") do
        local sizeX, sizeY = TBarriers:get_size()
        TBarriers:set_size(sizeX, sizeY + 8)
    end
    for BBarriers in map:get_entities("Bottom_Barrier_") do
        local sizeX, sizeY = BBarriers:get_size()
        local posX, posY, posL = BBarriers:get_position()
        BBarriers:set_position(posX, posY - 8, posL)
        BBarriers:set_size(sizeX, sizeY + 8)
     end
end

------------------------------------------------------------------------------

local function barrier_open()
  if timer_count <= 5 then
      definebarriers()
      if timer_count == 5 and not no_sound then
        sol.audio.play_sound("explosion")
        hero:set_walking_speed(88)
      elseif not no_sound then
       sol.audio.play_sound("hero_pushes")
      end
       timer_count = timer_count + 1
    return true
  else
    return false
  end
end

------------------------------------------------------------------------------

local function sewer_pulldoor()
      function Sewer_Sword_PullingDoor:on_activated_repeat()
        rupeedialoglu = 0
          if game:get_money() >= 20 and hero:get_state() == "pulling" and Sewer_Rupee_Door_Opened == nil then
             Sewer_Sword_PullingDoor:set_enabled(false)
             map:set_doors_open("Sewer_Sword_Rupee_")  
             sol.audio.play_sound("door_open")          
             game:remove_money(20)
          elseif game:get_money() < 20 and hero:get_state() == "pulling" and rupeedialoglu == 0 then
             game:start_dialog("NoRupees", function() rupeedialoglu = 1 end)
          end
      end 
end

------------------------------------------------------------------------------

local function start_drain()
           sol.audio.play_sound("secret")
           hero:freeze()
           sol.timer.start(500,function()
                              sol.audio.play_sound("water_drain_begin")
                                end)
       end

------------------------------------------------------------------------------
------------------------------------------------------------------------------

function map:on_started()
  RNGdrop:destructibles(map)
  Sewer_Sword_EDoor:open()
    if not game:get_value("sewer_drained") then
       map:set_entities_enabled("Sewer_Water_Stairs_", false)
       SubWater_1:set_enabled(true)
    else
       map:set_entities_enabled("Sewer_Water_Stairs_", true)
       SubWater_1:set_enabled(false)
       switch_water_drain:set_activated()
       timer_count = 1
       no_sound = true
       sol.timer.start(100, barrier_open)
    end
    if not game:get_value("Sewer_Rupee_Door_Opened") then
       sewer_pulldoor()
    end
    if game:get_value("Sword_Obtained") then
       map:set_entities_enabled("sewer_ennemy_", true)
    end
    if game:get_value("Container_Heart_1") then
      Sewer_Container_Heart:set_enabled(true)
      container_heart_capt:set_enabled(false)
      Sewer_Sword_WDoor:open()
    end 
    if game:get_value("Sewer_ECenter_Wwall_Explosed") then
      Sewer_Sword_SWwall_Wall:set_enabled(false)

      Sewer_Sword_SWwall_TopDoor:set_enabled(true)
    end
end

------------------------------------------------------------------------------

function Sewer_Sword_EDoor_Capt:on_activated()
Sewer_Sword_EDoor:close()
Sewer_Sword_EDoor_Capt:set_enabled(false)
end

------------------------------------------------------------------------------

function switch_water_drain:on_activated()
           local SubWater_Index = 1
              start_drain()
              sol.timer.start(500,function()     
                                 sol.audio.play_sound("water_drain")
                                 SubWater_1:set_enabled(false)
                                 local pgtile = map:get_entity("SubWater_g_".. SubWater_Index)
                                 local ngtile = map:get_entity("SubWater_g_".. (SubWater_Index +1))
                                 local pdtile = map:get_entity("SubWater_d_".. SubWater_Index)
                                 local ndtile = map:get_entity("SubWater_d_".. (SubWater_Index +1))
                                 pgtile:set_enabled(false) 
                                 pdtile:set_enabled(false) 
                                       if ngtile == nil or ndtile == nil then
                                          hero:unfreeze()
                                          map:set_entities_enabled("Sewer_Water_Stairs_", true)
                                          sol.audio.play_sound("explosion")
                                          hero:set_walking_speed(60)
                                          sol.timer.start(1000, barrier_open)
                                          return false
                                       end                                      
                                 ngtile:set_enabled(true) 
                                 ndtile:set_enabled(true) 
                                 SubWater_Index = SubWater_Index + 1
                                 return true
                                   end) 
           game:set_value("sewer_drained", 1)
        end

------------------------------------------------------------------------------


  function container_heart_capt:on_activated()  
    if game:get_value("Sewer_Sword_Shortcut_SDoor_Open") then  
      sol.audio.play_sound("secret")
      hero:freeze()
      container_heart_capt:set_enabled(false)
      sol.timer.start(750, function()
                        Sewer_Container_Heart:set_enabled(true)
                        sol.audio.play_sound("chest_appears")
                        hero:unfreeze()
                            end)
  end
end

------------------------------------------------------------------------------

function Sewer_Container_Heart:on_opened()
  hero:start_treasure("consumables/heart_container", 1)
  Sewer_Sword_WDoor:open()
end

------------------------------------------------------------------------------

function Sewer_Sword_Chest:on_opened()
  hero:start_treasure("equipment/sword", 1, nil, function() 
                                      map:set_entities_enabled("sewer_ennemy_", true)
                                                   end)
end

------------------------------------------------------------------------------

for Sewer_Enemies in map:get_entities("sewer_ennemy_") do
  function Sewer_Enemies:on_dead()
    if map:get_entities_count("sewer_ennemy_") == 0 then
       map:set_doors_open("Sewer_Sword_Shortcut_S")  
       sol.audio.play_sound("door_open")  
    end
  end
end

------------------------------------------------------------------------------

function map:on_opening_transition_finished()
end
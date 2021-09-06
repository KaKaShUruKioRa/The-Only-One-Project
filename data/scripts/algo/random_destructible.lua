local RNGdrop = {}  

--------------------------------------------------------------------
--------------------------------------------------------------------
local enemy = sol.main.get_metatable("enemy")
local destructible = sol.main.get_metatable("destructible")

--------------------------------------------------------------------
--------------------------------------------------------------------

  function RNGdrop:destructibles()
     function destructible:on_pre_draw(camera)
        if self:get_treasure() == nil then
          local RandNum = math.random(1000)
            if RandNum <= 40 then
               self:set_treasure("consumables/rupee", 1, nil)
            elseif RandNum <= 48 then
               self:set_treasure("consumables/rupee", 2, nil)
            elseif RandNum <= 50 then 
               self:set_treasure("consumables/rupee", 3, nil)
            elseif RandNum <= 90 then 
               self:set_treasure("consumables/heart", 1, nil)
            elseif RandNum <= 130 then 
               self:set_treasure("consumables/arrow_refill", 1, nil)
            elseif RandNum <= 138 then 
               self:set_treasure("consumables/arrow_refill", 2, nil)
            elseif RandNum <= 140 then 
               self:set_treasure("consumables/arrow_refill", 3, nil)
            elseif RandNum <= 180 then 
               self:set_treasure("consumables/bomb_refill", 1, nil)
            elseif RandNum <= 188 then 
               self:set_treasure("consumables/bomb_refill", 2, nil) 
            elseif RandNum <= 190 then 
               self:set_treasure("consumables/bomb_refill", 3, nil)
            elseif RandNum <= 230 then 
               self:set_treasure("consumables/magic_jar", 1, nil)
            elseif RandNum <= 232 then 
               self:set_treasure("consumables/magic_jar", 2, nil)
            elseif RandNum <= 234 then
               self:set_treasure("consumables/fairy", 1, nil)
            end
          end
      end
    end

--------------------------------------------------------------------

  function RNGdrop:enemies()
      function enemy:on_dying()
        if self:get_treasure() == nil then
          local RandNum = math.random(1000)
            if RandNum <= 40 then
               self:set_treasure("consumables/rupee", 1, nil)
            elseif RandNum <= 48 then
               self:set_treasure("consumables/rupee", 2, nil)
            elseif RandNum <= 50 then 
               self:set_treasure("consumables/rupee", 3, nil)
            elseif RandNum <= 90 then 
               self:set_treasure("consumables/heart", 1, nil)
            elseif RandNum <= 130 then 
               self:set_treasure("consumables/arrow_refill", 1, nil)
            elseif RandNum <= 138 then 
               self:set_treasure("consumables/arrow_refill", 2, nil)
            elseif RandNum <= 140 then 
               self:set_treasure("consumables/arrow_refill", 3, nil)
            elseif RandNum <= 180 then 
               self:set_treasure("consumables/bomb_refill", 1, nil)
            elseif RandNum <= 188 then 
               self:set_treasure("consumables/bomb_refill", 2, nil) 
            elseif RandNum <= 190 then 
               self:set_treasure("consumables/bomb_refill", 3, nil)
            elseif RandNum <= 230 then 
               self:set_treasure("consumables/magic_jar", 1, nil)
            elseif RandNum <= 232 then 
               self:set_treasure("consumables/magic_jar", 2, nil)
            elseif RandNum <= 234 then
               self:set_treasure("consumables/fairy", 1, nil)
            end
          end
      end
  end
--------------------------------------------------------------------

return RNGdrop
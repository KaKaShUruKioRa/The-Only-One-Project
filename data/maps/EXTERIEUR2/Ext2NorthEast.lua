local map = ...
local game = map:get_game()


--[[
local ifelsethen = require ("If_Else_Then")
v = 1
      sol.audio.play_music("sanctuary")
      game:start_dialog("test.defineA",
                               function(answer)
                                    if answer == 2 then sol.audio.play_sound("picked_small_key") a = 1 print ("A = " .. a)
                                    elseif answer == 3 then sol.audio.play_sound("wrong") a = 10 print ("A = " .. a)
                                    elseif answer == 4 then sol.audio.play_sound("wrong") a = 30 print ("A = " .. a)
                                    end
                                       game:start_dialog("test.defineB",
                                                          function(answer)
                                                               if answer == 2 then sol.audio.play_sound("picked_small_key") b = 2 print ("B = " .. b)
                                                               elseif answer == 3 then sol.audio.play_sound("wrong") b = 20 print ("B = " .. b)
                                                               elseif answer == 4 then sol.audio.play_sound("wrong") b = 200 print ("B = " .. b)
                                                           end
                                                              game:start_dialog("test.defineC",
                                                                                function(answer)
                                                                          if answer == 2 then sol.audio.play_sound("picked_small_key") c = 3  print ("C = " .. c)                                                                                        
                                                                                    elseif answer == 3 then sol.audio.play_sound("wrong") c = 33 print ("C = " .. c)
                                                                                          elseif answer == 4 then sol.audio.play_sound("wrong") c = 66 print ("C = " .. c)
                                                                                          end
                                                                                      
                                                                                 end) 
                                                          end)
                               end)

function map:on_suspended()
  ifelsethen:func() 
end

end

function map:on_key_pressed(p)

print ("V est égal à " .. v)

end
--]]
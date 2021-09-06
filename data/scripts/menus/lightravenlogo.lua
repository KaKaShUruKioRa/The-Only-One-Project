local lightravenlogo = {}
--déclaration de variable

  local lr_img = sol.surface.create("menus/lightraven_logo/lr112.png")
  --local musicbylr =  sol.text_surface.create("center", "center", alttp, "solid", "white", 11, "Music by Light Raven")
  
local movement = sol.movement.create("straight") --crée un objet movement qui va en ligne droite
  movement:set_angle(0) --Angle 0 = Se déplace vers l'East (droite)
  movement:set_speed(38) -- Se déplace à la vitesse de "48"
  movement:set_max_distance(264) -- ne se dépace au maximum que de 404 pixel
  movement:start(lr_img) --, function()     --le mouvement s'appliquera à l'image lr_img
                                            -- CallBack la fonction arrête l'écran Light Raven Logo quand le mouvement s'arrête
                         --sol.menu.stop(lightravenlogo) 
                         --sol.audio.stop_music()     
                         --end) 
local lr_text = sol.text_surface.create({
                                              font = "enter_command",
                                              font_size = 16,
                                              horizontal_alignment = "center",
                                              text = "Music By Light Raven !",
                                              })

      
 
function lightravenlogo:on_started()
  sol.audio.play_music("light_raven/lr_intro")

  sol.timer.start(lightravenlogo, 11000, 
              function()
                sol.menu.stop(lightravenlogo)
                sol.audio.stop_music()
              end)
end

function lightravenlogo:on_draw(dst_surface) --crée une function on_draw nommée lightravenlogo
 h, w = dst_surface:get_size()
 lr_img:draw(dst_surface, -160, 44 ) --dessine l'image chargée "lr_img" sur une surface en position -312(x),64(y))
 sol.timer.start(2000, function() lr_text:draw(dst_surface, (h/4)*2, (w/8)*5) end) --TODO : Affiché le Texte au bon moment
end

function lightravenlogo:on_key_pressed(key)
  sol.menu.stop(lightravenlogo)
  sol.audio.stop_music()
  return true
end

return lightravenlogo


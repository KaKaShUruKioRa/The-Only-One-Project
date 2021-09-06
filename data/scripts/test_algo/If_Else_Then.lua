local ifelsethen = {}

print ("Execution du require !")

  function ifelsethen:func()

    print ("execution de la fonction ifelsethenfunc()")
    print (a,b,c)
      if a == 1 and  b == 2 and c == 3 then sol.audio.play_sound("picked_small_key") print ("A B et C are Ok") 
      elseif a == 1 and  b == 2 then print ("A et B are Ok")
      elseif a == 1 and c == 3 then print ("A et C are Ok")
      elseif b == 2 and c == 3 then print ("B et C are Ok")
      elseif b == 2  then print ("B is Ok")
      elseif c == 3 then print ("C is Ok")
      else print ("Nothing Good") sol.audio.play_sound("wrong")
      end
  end 

function ifelsethen:none()

print ("il n'y a rien ici mais la fonction none() à bien été lancé")

end

return ifelsethen 
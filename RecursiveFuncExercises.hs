and :: [Bool] -> Bool
and []  = True
and (x:xs) 
    | x == False = False
    | otherwise and xs
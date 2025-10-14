and :: [Bool] -> Bool
and []  = True
and (x:xs) 
    | x == False = False
    | otherwise  = and xs

main  = IO()
main  = print(Main.and [True,True,False,True,True,True,True,True,True,True])
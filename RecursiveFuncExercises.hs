and :: [Bool] -> Bool
and []  = True
and (x:xs) 
    | x == False = False
    | otherwise  = Main.and xs

main  :: IO()
main  = print(Main.and [])
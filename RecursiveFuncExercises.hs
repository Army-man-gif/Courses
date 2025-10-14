-- Exercises

-- Exercise 1
and :: [Bool] -> Bool
and []  = True
and (x:xs) 
    | x == False = False
    | otherwise  = Main.and xs



-- Exercise 2
concat :: [[a]] -> [a]
concat [] = []
concat (x:xs) = x ++ Main.concat xs



main  :: IO()
main  = print(Main.concat [[1,2], [3,4], [5]] )



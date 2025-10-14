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

-- Exercise 3
replicate :: Int -> a -> [a]
replicate 0 x = []
replicate n x  = [x] ++ Main.replicate (n - 1) x



main  :: IO()
main  = print(Main.replicate 111111 'a' )



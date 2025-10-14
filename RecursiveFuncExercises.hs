{-# LANGUAGE NoImplicitPrelude #-}
import Prelude hiding ((!!), elem)

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
-- Exercise 4

(!!) :: [a] -> Int -> a
(x:_) !! 0  = x
(_:xs) !! n  = xs !! (n-1)
[]     !! _ = error "Index out of bounds"

-- Exercise 5
elem :: Eq a => a -> [a] -> Bool
elem val []  = False
elem val (x:xs)
    | x == val = True
    | otherwise = elem val xs

-- Exercise 6
merge :: Ord a => [a] -> [a] -> [a]
merge [] ys = ys
merge xs [] = xs
merge (x:xs) (y:ys)
    | x <= y    = x : merge xs (y:ys)
    | otherwise = y : merge (x:xs) ys


main  :: IO()
main = print (merge [2,5,6] [1,3,4])

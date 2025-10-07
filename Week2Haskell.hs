-- Silences all warnings
{-# OPTIONS_GHC -w #-}


removeLast :: [a] -> [a]
removeLast [] = []
removeLast xs = reverse (tail (reverse(xs)))

removeElem :: Int -> [a] -> [a]
removeElem _ [] =  []
removeElem n xs = removeLast (take n xs) ++ drop n xs

removeFirst :: [a] -> [a]
removeFirst [] = []
removeFirst xs = removeElem 1 xs

-- Start Exercise
removeBoth :: [a] -> [a]
removeBoth [] = []
removeBoth xs = removeFirst(removeLast(xs))
printEl  = putStr (show(removeBoth([1,2,3,4])))
-- End Exerecise

abs' :: Integer -> Integer
abs' n = if n >= 0 then n else -n

howMuchDoYouLikeHaskell :: Int -> String
howMuchDoYouLikeHaskell x = if x < 3 then "I dislike it!" else
                               if x < 7 then "It's ok!" else
                                 "It's fun!"

abs :: Int -> Int
abs n | n >= 0    = n
      | otherwise = -n



howMuchDoYouLikeHaskell2 :: Int -> String
howMuchDoYouLikeHaskell2 x | x < 3       = "I dislike it!"
                           | x < 7       = "It's ok!"
                           | otherwise   = "It's fun!"


-- Start Exercise
check :: Int -> Int -> Bool
check x y | x > y && x < (2*y) = True
          | otherwise = False
-- End Exercise
andB :: Bool -> Bool -> Bool
andB True True = True
andB True False = False
andB False True = False
andB False False = False

-- This is the same as above just shorter the "_" is a wildcard: it matches any input and ignores
-- it because all the last 3 have the same output no matter the input
andB' :: Bool -> Bool -> Bool
andB' True True = True
andB' _ _      = False

-- This is an even smarter way of writing it
-- If one input is False the output is False no matter what
-- If the input is True then the output depends on the other input
andB'' :: Bool -> Bool -> Bool
andB'' True b  = b
andB'' False _ = False

-- Start Exercise
orB :: Bool -> Bool -> Bool
orB False False = False
orB _ _ = True
-- End Exercise

isTrue' :: Bool -> Bool
isTrue' True = True
isTrue' False = error "not True"

fst :: (a,b) -> a
fst (x,y) = x

-- Since we don't use the y value of the tuple at all we can write it like this:
fst' :: (a,b) -> a
fst' (x,_) = x


fsy :: (a,b) -> b
fsy (x,y) = y

-- Same in the opposite way
-- Since we don't use the x value of the tuple at all we can write it like this:

fsy' :: (a,b) -> b
fsy' (_,y) = y

-- Similar logic can be applied to 3 or more component tuples
third :: (a, b, c) -> c
third (_, _, z) = z

-- We can match several tuples at the same time:

addVectors :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVectors (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)


-- Start Exercise
swap :: (a, b) -> (b, a)
swap (a,b) = (b,a)
-- End Exercise

-- Lists

-- List logic

isEmpty' :: [a] -> Bool
isEmpty' [] = True
isEmpty' (x:xs) = False

-- Same thing as list logic above but since x and xs are not acc being used so it's irrelevant
isEmpty'' :: [a] -> Bool
isEmpty'' [] = True
isEmpty'' (_:_) = False

sndElem :: [a] -> a
sndElem (_:x:_) = x

isEmpty2 :: [a] -> Bool
isEmpty2 x = case x of [] -> True
                       (_:_) -> False

double :: Int -> Int
double x = 2 * x

double' :: Int -> Int
double' = \x -> 2 * x

printCurrentExpression = putStr(show(sndElem [1,2,3,4,5,6,7,8,9,10]))



main :: IO()
main = printCurrentExpression
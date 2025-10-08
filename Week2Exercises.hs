{- 
      Exercises
      (Adapted and expanded from the book "Programming in Haskell)

      1) Define three variants of a function third :: [a] -> a that returns the third element in any list that contains at least this many elements, using

            a) head and tail
            b) list indexing !!
            c) pattern matching


      2) Define a function safetail :: [a] -> [a] that behaves like tail except that it maps [] to [] (instead of throwing an error). Using tail and isEmpty :: [a] -> Bool,
      define safetail using

            a) a conditional expression
            b) guarded equations
            c) pattern matching
-}

-- Start Exercise 1a
removeLast :: [a] -> [a]
removeLast xs = reverse (tail (reverse xs))

removeElem :: Int -> [a] -> [a]
removeElem n xs = removeLast (take n xs) ++ drop n xs

removeThird :: [a] -> [a]
removeThird [] = []
removeThird xs = removeElem 3 xs

callFunc = removeThird([1,2,3,4,5,6,7,8])
-- End Exercise

-- Start Exercise 1b
removeThird' :: [a] -> [a]
removeThird' xs
                | length xs < 3 = xs
                | otherwise  = [xs !! 0, xs !! 1] ++ drop 3 xs


-- End Exercise

-- Start Exercise 1c 

removeThird'' :: [a] -> [a]
removeThird'' [] = []
removeThird'' [x] = [x]
removeThird'' [x,y] = [x,y]
removeThird'' (x:y:_:zs) = x : y : zs

callFunc' = removeThird''([1,2,3,4,5,6,7,8])

main :: IO()
main = print callFunc'

-- End Exercise
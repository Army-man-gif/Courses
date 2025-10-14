{--
-- List comprehensions
import Data.Char
firstListComprehension = [x^2 | x <- [1..5]]
printFirstListComprehension = print(firstListComprehension)

-- Comprehensions can have multiple generators, separated by commas. For example:

secondListComprehension = [(x,y) | x <- [1,2,3], y <- [4,5]]
printsecondListComprehension = print(secondListComprehension)

-- Changing the order of the generators changes the order of the elements in the final list:

thirdListComprehension = [(x,y) | y <- [4,5], x <- [1,2,3]]
printthirdListComprehension = print([(x,y) | y <- [4,5], x <- [1,2,3]])

-- Later generators can depend on the variables that are introduced by earlier generators:

dependentGenerators = [(x,y) | x <- [1..3], y <- [x..2]]
printdependentGenerators = print(dependentGenerators)

concat :: [[a]] -> [a]
concat xss = [x | xs <- xss, x <- xs]

firsts :: [(a,b)] -> [a]
firsts ps = [x | (x, _) <- ps]

length :: [a] -> Int
length xs = sum [1 | _ <- xs]

evenNumberInThisRange = [x | x <- [1..10], even x]
printevenNumberInThisRange = print(evenNumberInThisRange)

factors :: Int -> [Int]
factors n = [x | x <- [1..n], n `mod` x == 0]

let2int :: Char -> Int
let2int c = ord c - ord 'a'

int2let :: Int -> Char
int2let n = chr (ord 'a' + n)

shift :: Int -> Char -> Char
shift n c | isLower c = int2let ((let2int c + n) `mod` 26)
          | otherwise = c

encode :: Int -> String -> String
encode n xs = [shift n x | x <- xs]
totalString = encode 3 "haskell is fun \n" ++ encode (-3) "kdvnhoo lv ixq"
--}

-- Exercises

-- Exercise 1
pyths :: Int -> [(Int,Int,Int)]
pyths max  = [(x,y,z) | x <- [1..max], y <- [1..max], z <- [1..max],x^2+y^2 == z^2]

-- Exercise 2
perfects :: Int -> [Int]

factors :: Int -> Int
factors n = sum[x | x <- [1..n-1], n `mod` x == 0]

perfects n = [x | x <- [1..n], x == factors x]






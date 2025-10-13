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


main :: IO()
main = printdependentGenerators
-- List comprehensions
import Data.Char
firstListComprehension = [x^2 | x <- [1..5]]
printFirstListComprehension = print(firstListComprehension)

secondListComprehension = [(x,y) | x <- [1,2,3], y <- [4,5]]
printsecondListComprehension = print(secondListComprehension)

thirdListComprehension = [(x,y) | y <- [4,5], x <- [1,2,3]]
printthirdListComprehension = print([(x,y) | y <- [4,5], x <- [1,2,3]])

main :: IO()
main = printthirdListComprehension
-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns -Wno-x-partial #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

{-
module MockTest ( isNBranching
                 , prune
                 , applyNTimes
                 , gameOver
                 , takeTokens
                 , isMagicSquare
                 , circuit
                 ) where
-}
import Types
import Data.List

-- Question 1
-- Branch [ Branch  [ Branch  [ Leaf a ] ] ]
isNBranching :: [Bool] -> Bool
isNBranching listOfAns
        | False `notElem` listOfAns = True
        | otherwise = False
helperFunction :: Int -> [Rose a] -> Bool
helperFunction n xs = isNBranching (map (secondHelper n) xs)

secondHelper :: Int -> Rose a -> Bool
secondHelper n (Leaf a) = True
secondHelper n (Branch xs)
    | length xs == n = True
    | otherwise  = False


-- Question 2
{-
applyNTimes :: Monad m => m a -> (a -> m a) -> Int -> m [a]
applyNTimes mx mf 1 = mx >>= mf
applyNTimes mx mf n = result : applyNTimes result mf (n-1)
                where
                    result = mx >>= mf
-}
-- Quesstion 3


-- Question 4
diag :: [[Int]] -> [Int]
diag diagonal = [diagonal !! n !! n | n <- [0..((length diagonal)^2-1)]]

check :: [[Int]] -> [[Int]] -> Bool
check xs ys = all (`elem` xs) ys


isMagicSquare :: [[Int]] -> Bool
isMagicSquare square = rowSum && colSum && diaSum
            where
             rowSum = check square square
             colSum = check (transpose square) (transpose square)
             diaSum = check ([diag square, diag (map reverse square)]) ([diag square, diag (map reverse square)])

-- Question 5

circuit :: Expr -> Circuit
circuit (Not (Var a)) = Nand (Input a) (Input a)
circuit (And (Var a) (Var b)) = Nand (Nand (Input a) (Input b)) (Nand (Input a) (Input b))

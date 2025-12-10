{-# OPTIONS_GHC -Wno-x-partial #-}

import Data.Char
import Data.List
import System.IO

size :: Int
size = 3

type Grid = [[Player]]

data Player = O | B | X
              deriving (Eq, Ord, Show)

next :: Player -> Player
next O = X
next B = B
next X = O

empty :: Grid
empty = replicate size (replicate size B)

full :: Grid -> Bool
full = all (/= B) . concat

turn :: Grid -> Player
turn g = if os <= xs then O else X
         where
           ps = concat g
           os = length (filter (== O) ps)
           xs = length (filter (== X) ps)

diag :: Grid -> [Player]
diag g = [g !! n !! n | n <- [0..size-1]]

wins :: Player -> Grid -> Bool
wins p g = any line (rows ++ cols ++ dias)
           where
             line = all (== p)
             rows = g
             cols = transpose g
             dias = [diag g, diag (map reverse g)]

won :: Grid -> Bool
won g = wins O g || wins X g

-- Moves

type Move = Int

valid :: Grid -> Move -> Bool
valid g i = 0 <= i && i < size^2 && concat g !! i == B

-- We need a auxiliary function to break a list into maximal segments of a given length:

chop :: Int -> [a] -> [[a]]
chop n [] = []
chop n xs = take n xs : chop n (drop n xs)

move :: Grid -> Move -> Player -> [Grid]
move g i p = if valid g i
               then [chop size (xs ++ [p] ++ ys)]
               else []
             where
               (xs,B:ys) = splitAt i (concat g)
-- Displaying a grid

interleave :: a -> [a] -> [a]
interleave x []     = []
interleave x [y]    = [y]
interleave x (y:ys) = y : x : interleave x ys

showPlayer :: Player -> [String]
showPlayer O = ["   ", " O ", "   "]
showPlayer B = ["   ", "   ", "   "]
showPlayer X = ["   ", " X ", "   "]


showRow' :: [Player] -> [String]
showRow' ps = beside (f ( g ps))
           where
             h :: [String] -> [String] -> [String]
             h = zipWith (++)

             beside :: [[String]] -> [String]
             beside = foldr1 h

             bar :: [String]
             bar = replicate 3 "|"

             f :: [[String]] -> [[String]]
             f = interleave bar

             g :: [Player] -> [[String]]
             g = map showPlayer

putGrid :: Grid -> IO ()
putGrid = putStrLn . unlines . concat . interleave bar . map showRow'
          where
            bar = [replicate (size*4 - 1) '-']

-- Reading a natural number

getNat :: String -> IO Int
getNat prompt = do putStr prompt
                   xs <- getLine
                   if xs /= [] && all isDigit xs then
                      return (read xs)
                   else
                      do putStrLn "ERROR: Invalid number"
                         getNat prompt

-- Human vs. human
tictactoe :: IO ()
tictactoe = run empty O

run :: Grid -> Player -> IO ()
run g p = do cls
             goto (1,1)
             putGrid g
             run' g p

run' :: Grid -> Player -> IO ()
run' g p | wins O g  = putStrLn "Player O wins!\n"
         | wins X g  = putStrLn "Player X wins!\n"
         | full g    = putStrLn "It's a draw!\n"
         | otherwise =
              do i <- getNat (prompt p)
                 case move g i p of
                    []   -> do putStrLn "ERROR: Invalid move"
                               run' g p
                    [g'] -> run g' (next p)

prompt :: Player -> String
prompt p = "Player " ++ show p ++ ", enter your move: "

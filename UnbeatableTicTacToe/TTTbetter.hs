{-# OPTIONS_GHC -Wno-x-partial #-}

import Data.Char
import Data.List
import System.IO
{-
A better way to do the same thing
We modify the book code to implement our own instance of the Ord
type class, to make the min and max (and hence minimum and
maximum) functions lazier than they are when we automatically derive
them.
Instead of asking Haskell to derive Ord automatically, we ask
-}
data Tree a = Node a [Tree a]
              deriving Show
size :: Int
size = 3


data Player' = O' | B' | X'
--            deriving (Eq, Ord, Show)
              deriving (Eq, Show)
type Grid' = [[Player']]

instance Ord Player' where
  O' <= _ = True
  _ <= X' = True
  B' <= p = p == B' || p == X'
  p <= B' = p == O' || p == B'

  min O' _ = O'
  min B' p = if p == X' then B' else p
  min X' p = p

  max O' p = p
  max B' p = if p == O' then B' else p
  max X' _ = X'

diag' :: Grid' -> [Player']
diag' g = [g !! n !! n | n <- [0..size-1]]

turn' :: Grid' -> Player'
turn' g = if os <= xs then O' else X'
         where
           ps = concat g
           os = length (filter (== O') ps)
           xs = length (filter (== X') ps)
wins' :: Player' -> Grid' -> Bool
wins' p g = any line (rows ++ cols ++ dias)
           where
             line = all (== p)
             rows = g
             cols = transpose g
             dias = [diag' g, diag' (map reverse g)]

{-
The most important property of min is that min O p doesn't evaluate p due to laziness, 
and similarly max X p doesn't evaluate p due to laziness. This is a kind of short-circuit evaluation as discussed earlier.
Because minimum and maximum are defined from min and max using fold, they inherit the laziness of min and max and so become faster.
Sometimes laziness pays off.
-}

alphabeta :: Tree Grid' -> Tree (Grid',Player')
alphabeta (Node g [])
   | wins' O' g  = Node (g,O') []
   | wins' X' g  = Node (g,X') []
   | otherwise = Node (g,B') []
alphabeta (Node g ts)
   | turn' g == O' = Node (g, minimum o) (take (length o) ts')
   | turn' g == X' = Node (g, maximum x) (take (length x) ts')
                   where
                     ts' = map alphabeta ts
                     ps  = [p | Node (_,p) _ <- ts']
                     o = takeUntil (== O') ps
                     x = takeUntil (== X') ps

takeUntil :: (a -> Bool) -> [a] -> [a]
takeUntil p [] = []
takeUntil p (x : xs) | p x       = [x]
                     | otherwise = x : takeUntil p xs

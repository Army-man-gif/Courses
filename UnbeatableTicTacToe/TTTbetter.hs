{-# OPTIONS_GHC -Wno-x-partial #-}

import Data.Char
import Data.List
import System.IO
import TTT
{-
A better way to do the same thing
We modify the book code to implement our own instance of the Ord
type class, to make the min and max (and hence minimum and
maximum) functions lazier than they are when we automatically derive
them.
Instead of asking Haskell to derive Ord automatically, we ask
-}


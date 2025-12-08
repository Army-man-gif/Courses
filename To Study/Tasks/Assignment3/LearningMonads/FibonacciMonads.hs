{-# LANGUAGE MonadComprehensions #-}
{-# OPTIONS_GHC -Wno-noncanonical-monad-instances #-}
{-# OPTIONS_GHC -Wno-x-partial #-}




module FibonacciMonads where 


import Control.Monad.Writer
import Control.Monad.State

import Control.Applicative
import Data.Char

fib :: Integer -> Integer
fib 0 = 0
fib 1 = 1
fib n = fib (n-2) + fib (n-1)

-- General Monad definition. Works for any monad
fibm :: Monad m => Integer -> m Integer
fibm 0 = pure 0
fibm 1 = pure 1
fibm n = do
          x <- fibm (n-2)
          y <- fibm (n-1)
          pure (x+y)

{-
Specialised Monads for these specific examples: 

ghci> fibm 11 :: Maybe Integer
Just 89
ghci> fibm 11 :: [Integer]
[89]

-}

fibMaybe :: Integer -> Maybe Integer
fibMaybe = fibm

fibList :: Integer -> [Integer]
fibList = fibm


-- List comprehension version
fibList' :: Integer -> [Integer]
fibList' 0 = pure 0 -- equivalent to [0]
fibList' 1 = pure 1 -- equivalent to [1]
fibList' n = [ x+y | x <- fibList' (n-2), y <- fibList' (n-1)]

-- Monadic equivalent
fibm' :: Monad m => Integer -> m Integer
fibm' 0 = pure 0
fibm' 1 = pure 1
fibm' n = [ x+y | x <- fibm' (n-2), y <- fibm' (n-1)]

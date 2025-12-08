
module StateMonad where

import Control.Monad.State
    
{-

       State s a ≈ s -> (a, s)
       Monadic built in implementation of pure
       pure :: a -> State s a
       pure x = State $ \s -> (x, s)

       (>>=) :: State s a -> (a -> State s b) -> State s b
       m >>= f = State $ \s ->
              let (a, s') = runState m s   -- run first computation
              in runState (f a) s'          -- feed its result to next computation

-}
fib5 :: Integer -> State Int Integer
fib5 n | n <  0 = error ("invalid input " ++ show n)
       | n == 0 = pure 0
       | n == 1 = pure 1
       | n >= 2 = do
                    modify (+1)
                    x <- fib5 (n-2)
                    y <- fib5 (n-1)
                    pure (x+y)

fib' :: Integer -> Integer
fib' n = x
 where
  f :: Integer -> State (Integer, Integer) ()
  f 0 = pure ()
  f n = do
         modify (\(x,y) -> (y, x+y))
         f (n-1)

  ((),(x,y)) = runState (f n) (0,1)

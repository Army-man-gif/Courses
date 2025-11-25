
module StateMonad where

import Control.Monad.State
    
fib5 :: Integer -> State Int Integer
fib5 n | n <  0 = error ("invalid input " ++ show n)
       | n == 0 = pure 0
       | n == 1 = pure 1
       | n >= 2 = do
                    modify (+1)
                    x <- fib5 (n-2)
                    y <- fib5 (n-1)
                    pure (x+y)

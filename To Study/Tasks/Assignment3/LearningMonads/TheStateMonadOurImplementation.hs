module TheStateMonadOurImplementation where 

import Control.Monad.State

data State' s a = T (s -> (a,s))

-- The destructor (the function opposite to the constructor T) is traditionally called runState:
-- Destructor is just an unwrapper of the custom type
runState' :: State' s a -> (s -> (a, s))
runState' (T p) = p

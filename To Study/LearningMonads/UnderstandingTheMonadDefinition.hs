{-# LANGUAGE InstanceSigs #-}

module UnderstandingTheMonadDefinition where 

data Box a = Box a
  deriving Show


-- Sort of unpacakages the Function. So the "context" or custom type of the input to the 
-- function is removed, the function applied, then the custom type wrapped around the answer
-- and returned

{- 
  class Functor f where
  fmap :: (a -> b) -> f a -> f b
-}
instance Functor Box where
  fmap :: (a -> b) -> Box a -> Box b
  fmap f (Box x) = Box (f x)    



{- 
  class Functor f => Applicative f where
  pure  :: a -> f a
  (<*>) :: f (a -> b) -> f a -> f b
-}

-- Slightly more complicated than Functor
-- It unwraps both the function and input value then wraps the result in the custom type again
instance Applicative Box where
  pure :: a -> Box a
  pure x = Box x

  (<*>) :: Box (a -> b) -> Box a -> Box b
  (Box f) <*> (Box x) = Box (f x)


{- 
  class Applicative m => Monad m where
  return :: a -> m a
  (>>=)  :: m a -> (a -> m b) -> m b
-}

-- So it takes an input wrapped in the custom type + a function that takes a normal
-- value and returns the applied function output wrapped in the custom type
-- then obviously just implied that the output of Monad is the custom type
-- Allows chaining like:
  --  Box 10 >>= add3 >>= double
instance Monad Box where
  return = pure

  (>>=) :: Box a -> (a -> Box b) -> Box b
  (Box x) >>= f = f x

add3 :: Int -> Box Int
add3 x = Box (x + 3)

double :: Int -> Box Int
double x = Box (x * 2)
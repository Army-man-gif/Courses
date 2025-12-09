-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

module Assignment3 (toRose, fromRose, trace, roundRobin, schedule) where

import Types
import Control.Monad.State
import Data.Functor.Identity
import Data.List

toRose :: Free [] a -> Rose a 
toRose (Pure x) = Lf x
toRose (Free []) = Br []
toRose (Free xs) = Br (apply xs)
    where
        apply [] = []
        apply (y:ys) = toRose y : apply ys


fromRose :: Rose a -> Free [] a
fromRose (Lf x) = Pure x
fromRose (Br []) = Free []
-- + doesn't work heresince we're tryna build a list
-- gotta use : or ++ but : requires a datatype on left
-- and the list of that datatype on the right
-- i.e Free [] a on left and [ Free [] a ] on right
-- hence the where
fromRose (Br (x:xs)) = Free(fromRose x : remainder)
    where
        remainder = case fromRose (Br xs) of
            Free ys -> ys
            Pure _ -> error "Impossible"

trace :: FreeState s a -> State ([s],s) a
trace (Pure a) = return a
-- Extract the inner State from the Free    
trace (Free computation) = do
    -- Gets the history of states, and the current one
    (previousStates,currentState) <- get
    -- Runs the current State computation using the current state
        -- Lazily computing ONLY the next step. not recursing
        -- Leaves the "newState" as more and more complex
        -- Until the base case hits and it unwraps
    -- producing the next step in the Free monad and the new state
    let (next, newState) = runState computation currentState
    -- Updates the old state memory and newState
    put([newState] ++ previousStates,newState)
    -- Recurses
    trace next




-- Show instances so I can debug as I go
instance Show a => Show (Free [] a) where
    show (Pure x) = "Pure " ++ show x
    show (Free xs) = "Free " ++ show xs
instance Eq a => Eq (Free [] a) where
    Pure x == Pure y     = x == y
    Free xs == Free ys   = xs == ys
    _ == _               = False
instance Eq a => Eq (Rose a) where
    Lf x == Lf y     = x == y
    Br xs == Br ys   = xs == ys
    _ == _               = False

r1 :: Rose Int
-- Pure 42
r1 = Lf 42

r2 :: Rose Int
decode :: Free [] Int
decode = Free [Pure 1,Pure 2,Free [Pure 3]]
r2 = Br [Lf 1, Lf 2, Br [Lf 3]] 

roundRobin :: [YieldState s ()] -> State s ()
roundRobin [] = return ()
roundRobin (currentThread : otherThreads) = case currentThread of
    Pure _ -> roundRobin otherThreads 
    Free (FLeft state) -> do
        currentState <- get
        let (nextInstructions,newState) = runState state currentState
        put newState
        roundRobin (nextInstructions : otherThreads)
    Free (FRight (Yield nextInstructions)) ->
        roundRobin (otherThreads ++ [nextInstructions])

charWriter :: Char -> YieldState String ()
charWriter c = do s <- getY
                  if (length s > 10) then pure () else
                    do putY (c:s)
                       yield
                       charWriter c 
yieldExample :: [YieldState String ()]
yieldExample = [charWriter 'a', charWriter 'b', charWriter 'c'] 


execute :: [(SleepState s (),Int)] -> State s ()
execute [] = return ()
execute xs = case findIndex(\(_,sleepCounter) -> sleepCounter == 0) xs of
    Nothing -> do
        let decremented = [(thread,(max 0 (counter-1))) | (thread,counter) <- xs]
        execute decremented
    Just indexNeeded ->
        let
            (previousThreads,(currentThread,_):remainingThreads) = splitAt indexNeeded xs
            otherThreads = previousThreads ++ remainingThreads
            otherThreadsForFreeLeft = [(thread, max 0 (counter - 1)) | (thread, counter) <- otherThreads]
            previousThreadsForFreeLeft = [(thread, max 0 (counter - 1)) | (thread, counter) <- previousThreads]
            remainingThreadsForFreeLeft = [(thread, max 0 (counter - 1)) | (thread, counter) <- remainingThreads]

        in
            case currentThread of
                Pure _ -> execute otherThreadsForFreeLeft
                Free (FLeft state) -> do
                    currentState <- get
                    let (nextInstructions,newState) = runState state currentState
                    put newState
                    execute (previousThreadsForFreeLeft ++ [(nextInstructions,0)] ++ remainingThreadsForFreeLeft)
                Free (FRight (Sleep tm nextInstructions)) ->
                    execute (previousThreads ++ [(nextInstructions,tm)] ++ remainingThreads)

schedule :: [SleepState s ()] -> State s ()
schedule [] = return ()
schedule listofThreads = execute (zip listofThreads (replicate (length listofThreads) 0))



main :: IO()
main = print(toRose decode == r2)
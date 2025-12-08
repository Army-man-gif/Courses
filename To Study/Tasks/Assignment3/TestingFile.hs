{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}
module TestingFile where
import Types 

-- Test 1
-- Thread that writes 'x' three times, sleeps 3 steps, writes once more
sleepThread4 :: SleepState String ()
sleepThread4 = do
  appendChar 'x'
  appendChar 'x'
  appendChar 'x'
  sleep 3
  appendChar 'x'

-- Thread that sleeps 1 step, writes 'y' twice, sleeps 2 steps, writes 'y' once
sleepThread5 :: SleepState String ()
sleepThread5 = do
  sleep 1
  appendChar 'y'
  appendChar 'y'
  sleep 2
  appendChar 'y'

-- Thread that alternates writes and sleeps: write 'z', sleep 2, write 'z', sleep 1
sleepThread6 :: SleepState String ()
sleepThread6 = do
  appendChar 'z'
  sleep 2
  appendChar 'z'
  sleep 1

-- Thread that sleeps 5 steps at the start, then writes 'm' once
sleepThread7 :: SleepState String ()
sleepThread7 = do
  sleep 5
  appendChar 'm'

-- Thread that writes 'n', sleeps 1, writes 'n', sleeps 1, writes 'n' (quick bursts)
sleepThread8 :: SleepState String ()
sleepThread8 = do
  appendChar 'n'
  sleep 1
  appendChar 'n'
  sleep 1
  appendChar 'n'

-- Combine them into a list to test
sleepExampleExtended :: [SleepState String ()]
sleepExampleExtended = [sleepThread1, sleepThread2, sleepThread3, sleepThread4, sleepThread5, sleepThread6, sleepThread7, sleepThread8]

-- Test 2
-- Thread that writes 'p', sleeps 3, writes 'p', sleeps 2, writes 'p'
sleepThread9 :: SleepState String ()
sleepThread9 = do
  appendChar 'p'
  sleep 3
  appendChar 'p'
  sleep 2
  appendChar 'p'

-- Thread that sleeps 2 at the start, then writes 'q' 4 times consecutively
sleepThread10 :: SleepState String ()
sleepThread10 = do
  sleep 2
  appendChar 'q'
  appendChar 'q'
  appendChar 'q'
  appendChar 'q'

-- Thread that alternates quickly: write 'r', sleep 1, write 'r', sleep 1, write 'r', sleep 1
sleepThread11 :: SleepState String ()
sleepThread11 = do
  appendChar 'r'
  sleep 1
  appendChar 'r'
  sleep 1
  appendChar 'r'
  sleep 1
sleepExampleExtra :: [SleepState String ()]
sleepExampleExtra = [sleepThread9, sleepThread10, sleepThread11]


-- Test 3
-- Thread A: write 'A', sleep 2, write 'A', sleep 1, write 'A'
sleepThreadA :: SleepState String ()
sleepThreadA = do
  appendChar 'A'
  sleep 2
  appendChar 'A'
  sleep 1
  appendChar 'A'

-- Thread B: sleep 3 at start, write 'B' 3 times consecutively
sleepThreadB :: SleepState String ()
sleepThreadB = do
  sleep 3
  appendChar 'B'
  appendChar 'B'
  appendChar 'B'

-- Thread C: alternating writes and sleeps: 'C', sleep 1, 'C', sleep 2
sleepThreadC :: SleepState String ()
sleepThreadC = do
  appendChar 'C'
  sleep 1
  appendChar 'C'
  sleep 2

-- Thread D: burst write of 'D' 5 times, sleep 4
sleepThreadD :: SleepState String ()
sleepThreadD = do
  appendChar 'D'
  appendChar 'D'
  appendChar 'D'
  appendChar 'D'
  appendChar 'D'
  sleep 4

-- Thread E: sleep 1, write 'E', sleep 1, write 'E', sleep 1, write 'E', sleep 1
sleepThreadE :: SleepState String ()
sleepThreadE = do
  sleep 1
  appendChar 'E'
  sleep 1
  appendChar 'E'
  sleep 1
  appendChar 'E'
  sleep 1

-- Combined complex example
sleepExampleComplex :: [SleepState String ()]
sleepExampleComplex = [sleepThreadA, sleepThreadB, sleepThreadC, sleepThreadD, sleepThreadE]

-- Test 4

-- Thread 1: write '1', sleep 3, write '1', sleep 2
sleepThread12 :: SleepState String ()
sleepThread12 = do
  appendChar '1'
  sleep 3
  appendChar '1'
  sleep 2

-- Thread 2: sleep 2, write '2', write '2', sleep 1
sleepThread13 :: SleepState String ()
sleepThread13 = do
  sleep 2
  appendChar '2'
  appendChar '2'
  sleep 1

-- Thread 3: write '3', sleep 1, write '3', sleep 1
sleepThread14 :: SleepState String ()
sleepThread14 = do
  appendChar '3'
  sleep 1
  appendChar '3'
  sleep 1

-- Thread 4: sleep 1, write '4', sleep 2, write '4', write '4'
sleepThread15 :: SleepState String ()
sleepThread15 = do
  sleep 1
  appendChar '4'
  sleep 2
  appendChar '4'
  appendChar '4'

-- Thread 5: write '5' x3, sleep 4
sleepThread16 :: SleepState String ()
sleepThread16 = do
  appendChar '5'
  appendChar '5'
  appendChar '5'
  sleep 4

-- Thread 6: sleep 3, write '6', sleep 1, write '6'
sleepThread17 :: SleepState String ()
sleepThread17 = do
  sleep 3
  appendChar '6'
  sleep 1
  appendChar '6'

-- Thread 7: write '7', sleep 1, write '7', sleep 1, write '7'
sleepThread18 :: SleepState String ()
sleepThread18 = do
  appendChar '7'
  sleep 1
  appendChar '7'
  sleep 1
  appendChar '7'

-- Thread 8: sleep 2, write '8', sleep 2, write '8', sleep 1
sleepThread19 :: SleepState String ()
sleepThread19 = do
  sleep 2
  appendChar '8'
  sleep 2
  appendChar '8'
  sleep 1

-- Combine into complex list
sleepExampleMega :: [SleepState String ()]
sleepExampleMega = [sleepThread12,sleepThread13,sleepThread14,sleepThread15,sleepThread16,sleepThread17,sleepThread18,sleepThread19]

-- execState (schedule sleepExampleMega) ""

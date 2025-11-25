module FactorialInMonadForm where
fac :: Int -> IO Int
fac n | n == 0    = pure 1
      | otherwise = do
                     putStrLn ("n = " ++ show n)
                     y <- fac (n-1)
                     pure (y * n)

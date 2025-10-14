-- Exercises

-- Exercise 1
pyths :: Int -> [(Int,Int,Int)]
pyths max  = [(x,y,z) | x <- [1..max], y <- [1..max], z <- [1..max],x^2+y^2 == z^2]

-- Exercise 2
perfects :: Int -> [Int]

factors :: Int -> Int
factors n = sum[x | x <- [1..n-1], n `mod` x == 0]

perfects n = [x | x <- [1..n], x == factors x]

-- Exercise 3
scaProduct :: [Int] -> [Int] -> Int
scaProduct xs ys = sum[xsᵢ * ysᵢ | (xsᵢ,ysᵢ) <- zip xs ys]
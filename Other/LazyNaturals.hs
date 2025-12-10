checkLengthBiggerThan' :: [a] -> Int -> Bool
checkLengthBiggerThan' []     0 = False
checkLengthBiggerThan' xs     0 = True
checkLengthBiggerThan' []     n = False
checkLengthBiggerThan' (x:xs) n = checkLengthBiggerThan' xs (n-1)

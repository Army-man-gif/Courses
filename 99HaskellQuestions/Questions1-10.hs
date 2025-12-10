-- Question 1
myLast :: [a] -> a 
myLast [] = error "Empty list"
myLast [a] = a
myLast (x:xs) = myLast xs

-- Question 2
myButLast :: [a] -> a
myButLast []  = error "Empty list"
myButLast [a1,a2] = a1
myButLast (x:xs) = myButLast xs

-- Question 3
elementAt :: [a] -> Int -> a
elementAt [] _ = error "Empty list"
elementAt (x:xs) 1 = x
elementAt (x:xs) n  = elementAt xs (n-1)
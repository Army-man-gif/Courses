-- Question 1
myLast :: [a] -> a 
myLast [a] = a
myLast (x:xs) = myLast xs

-- Question 2
myButLast :: [a] -> a
myButLast [a1,a2] = a1
myButLast (x:xs) = myButLast xs
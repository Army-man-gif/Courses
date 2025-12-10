-- Question 1
myLast :: [a] -> a 
myLast [] = error "Empty list"
myLast [a] = a
myLast (x:xs) = myLast xs

-- Question 2
myButLast :: [a] -> a
myButLast []  = error "Empty list"
myButLast [a] = error "List too short"
myButLast [a1,a2] = a1
myButLast (x:xs) = myButLast xs

-- Question 3
elementAt :: [a] -> Int -> a
elementAt [] _ = error "Empty list"
elementAt (x:xs) 1 = x
elementAt (x:xs) n  = elementAt xs (n-1)

-- Question 4

myLength :: [a] -> Int
myLength [] = 0
myLength (x:xs) = 1 + myLength xs

-- Question 5

myReverse :: [a] -> [a]
myReverse [] = []
myReverse [a] = [a]
myReverse (x:xs) = myReverse xs ++ [x]

-- Question 6

isPalindrome :: Eq a => [a] -> Bool
isPalindrome [] = True
isPalindrome [a] = True
isPalindrome xs = myReverse xs == xs

-- Question 7
data NestedList a = Elem a | List [NestedList a]

flatten :: NestedList a -> [a]
flatten (Elem a) = [a]
flatten (List []) = []
flatten (List (x:xs)) = flatten x ++ flatten (List xs)

-- Question 8

compress :: Eq a => [a] -> [a]
compress [] = []
compress [x] = [x]
compress (x:rest@(y:ys))
    | x == y = compress rest
    | otherwise  = x : compress rest

-- Question 9
pack :: Eq a => [a] -> [[a]]
pack []  = []
pack entireList@(x:xs) = collected : pack rest
    where
        collected = subList x entireList
        rest = drop (length collected) entireList

        subList _ [] = []
        subList y (z:zs)
            | y == z = z: subList y zs
            | otherwise = []

-- Question 10
encode :: Eq a => [a] -> [(Int,a)]
encode []  = []
encode entireList@(x:xs) = (collected,x) : encode rest
    where
        collected = counter x entireList
        rest = drop collected entireList

        counter _ [] = 0
        counter y (z:zs)
            | y == z = 1 + counter y zs
            | otherwise = 0

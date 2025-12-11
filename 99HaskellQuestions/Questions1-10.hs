-- Question 1
myLast :: [a] -> a 
myLast [] = error "Empty list"
myLast [a] = a
myLast (x:xs) = myLast xs

-- myLast [1,2,3,4]
-- myLast ['x','y','z']
-- Question 2
myButLast :: [a] -> a
myButLast []  = error "Empty list"
myButLast [a] = error "List too short"
myButLast [a1,a2] = a1
myButLast (x:xs) = myButLast xs

-- myButLast [1,2,3,4]
-- myButLast ['a'..'z']
-- Question 3
elementAt :: [a] -> Int -> a
elementAt [] _ = error "Empty list"
elementAt (x:xs) 1 = x
elementAt (x:xs) n  = elementAt xs (n-1)

-- elementAt [1,2,3] 2
-- elementAt "haskell" 5

-- Question 4

myLength :: [a] -> Int
myLength [] = 0
myLength (x:xs) = 1 + myLength xs

-- myLength [123, 456, 789]
-- myLength "Hello, world!"

-- Question 5

myReverse :: [a] -> [a]
myReverse [] = []
myReverse [a] = [a]
myReverse (x:xs) = myReverse xs ++ [x]

-- myReverse "A man, a plan, a canal, panama!"
-- myReverse [1,2,3,4]

-- Question 6

isPalindrome :: Eq a => [a] -> Bool
isPalindrome [] = True
isPalindrome [a] = True
isPalindrome xs = myReverse xs == xs

-- isPalindrome [1,2,3]
-- isPalindrome "madamimadam"
-- isPalindrome [1,2,4,8,16,8,4,2,1]

-- Question 7
data NestedList a = Elem a | List [NestedList a]

flatten :: NestedList a -> [a]
flatten (Elem a) = [a]
flatten (List []) = []
flatten (List (x:xs)) = flatten x ++ flatten (List xs)

-- flatten (Elem 5)
-- flatten (List [Elem 1, List [Elem 2, List [Elem 3, Elem 4], Elem 5]])
-- flatten (List [])

-- Question 8

compress :: Eq a => [a] -> [a]
compress [] = []
compress [x] = [x]
compress (x:rest@(y:ys))
    | x == y = compress rest
    | otherwise  = x : compress rest

-- compress "aaaabccaadeeee"

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

-- pack ['a', 'a', 'a', 'a', 'b', 'c', 'c', 'a', 'a', 'd', 'e', 'e', 'e', 'e']

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

-- encode "aaaabccaadeeee"
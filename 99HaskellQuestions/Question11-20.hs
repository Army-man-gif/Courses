-- Question 11
data ListElement a = Single a | Multiple Int a deriving Show

encodeModified  :: Eq a => [a] -> [ListElement a]
encodeModified  []  = []
encodeModified  entireList@(x:xs)
    | collected == 1 = Single x : encodeModified rest
    | otherwise = Multiple collected x : encodeModified rest
    where
        collected = counter x entireList
        rest = drop collected entireList

        counter _ [] = 0
        counter y (z:zs)
            | y == z = 1 + counter y zs
            | otherwise = 0
-- encodeModified "aaaabccaadeeee"
-- Question 12
decodeModified  :: Eq a => [ListElement a] -> [a]
decodeModified [] = []
decodeModified (Multiple n a : xs) = replicate n a ++ decodeModified xs
decodeModified (Single a : xs) = a : decodeModified xs

-- decodeModified [Multiple 4 'a',Single 'b',Multiple 2 'c', Multiple 2 'a',Single 'd',Multiple 4 'e']
-- Question 13
encodeDirect :: Eq a => [a] -> [ListElement a]
encodeDirect [] = []
encodeDirect (x:xs) = 
    let
        tracker 1 [] = (1,[])
        tracker n [] = (n, [])
        tracker n (y:ys)
            | x == y = tracker (n+1) ys
            | otherwise  = (n,y:ys)
        (count,rest) = tracker 1 xs
    in
        if count == 1
            then Single x :  encodeDirect rest
            else Multiple count x: encodeDirect rest

-- encodeDirect "aaaabccaadeeee"
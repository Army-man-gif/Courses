-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}


import Data.List

data Atom = Beep | Silence
  deriving (Eq, Show)

type Code = [Atom]

dit, dah, shortGap, mediumGap :: Code
dit       = [Beep, Silence]
dah       = [Beep, Beep, Beep, Silence]
shortGap  = replicate (3-1) Silence
mediumGap = replicate (7-1) Silence

morseCode :: Char -> Code
morseCode 'A' = dit ++ dah
morseCode 'B' = dah ++ dit ++ dit ++ dit
morseCode 'C' = dah ++ dit ++ dah ++ dit
morseCode 'D' = dah ++ dit ++ dit
morseCode 'E' = dit
morseCode 'F' = dit ++ dit ++ dah ++ dit
morseCode 'G' = dah ++ dah ++ dit
morseCode 'H' = dit ++ dit ++ dit ++ dit
morseCode 'I' = dit ++ dit
morseCode 'J' = dit ++ dah ++ dah ++ dah
morseCode 'K' = dah ++ dit ++ dah
morseCode 'L' = dit ++ dah ++ dit ++ dit
morseCode 'M' = dah ++ dah
morseCode 'N' = dah ++ dit
morseCode 'O' = dah ++ dah ++ dah
morseCode 'P' = dit ++ dah ++ dah ++ dit
morseCode 'Q' = dah ++ dah ++ dit ++ dah
morseCode 'R' = dit ++ dah ++ dit
morseCode 'S' = dit ++ dit ++ dit
morseCode 'T' = dah
morseCode 'U' = dit ++ dit ++ dah
morseCode 'V' = dit ++ dit ++ dit ++ dah
morseCode 'W' = dit ++ dah ++ dah
morseCode 'X' = dah ++ dit ++ dit ++ dah
morseCode 'Y' = dah ++ dit ++ dah ++ dah
morseCode 'Z' = dah ++ dah ++ dit ++ dit
morseCode '1' = dit ++ dah ++ dah ++ dah ++ dah
morseCode '2' = dit ++ dit ++ dah ++ dah ++ dah
morseCode '3' = dit ++ dit ++ dit ++ dah ++ dah
morseCode '4' = dit ++ dit ++ dit ++ dit ++ dah
morseCode '5' = dit ++ dit ++ dit ++ dit ++ dit
morseCode '6' = dah ++ dit ++ dit ++ dit ++ dit
morseCode '7' = dah ++ dah ++ dit ++ dit ++ dit
morseCode '8' = dah ++ dah ++ dah ++ dit ++ dit
morseCode '9' = dah ++ dah ++ dah ++ dah ++ dit
morseCode '0' = dah ++ dah ++ dah ++ dah ++ dah
morseCode  _  = undefined -- Avoid warnings

type Table = [(Char, Code)]

morseTable :: Table
morseTable = [ (c , morseCode c) | c <- ['A'..'Z']++['0'..'9'] ]

encodeChar :: Table -> Char -> Code
encodeChar table character  = case lookup character table of
    Just encodedValue -> encodedValue
    Nothing -> error ("The character " ++ [character] ++ " was not found in the encoding table, so therefore has no encoded value to return")

addShortGap :: Code -> Int -> Int -> Code
addShortGap code index totalLength 
    | index < (totalLength - 1)  = code ++ shortGap
    | otherwise = code

encodeWord :: Table -> String -> Code
encodeWord table word = concat[ addShortGap (encodeChar table character) index len | (index,character) <- zip [0..] word]
                                        where 
                                            len = length word

q1PartA :: [Code]
q1PartA = [encodeWord morseTable "", encodeWord morseTable "A", encodeWord morseTable "0", encodeWord morseTable "HELLO", encodeWord morseTable "WORLD"]

addMediumGap :: Code -> Int -> Int -> Code
addMediumGap code index totalLength 
    | index < (totalLength - 1)  = code ++ mediumGap
    | otherwise = code

encodeWords :: Table -> [String] -> Code
encodeWords table words = concat[ addMediumGap (encodeWord table word) index len | (index, word) <- zip [0..] words]
                                    where
                                        len = length words

q1PartB :: [Code]
q1PartB = [encodeWords morseTable [], encodeWords morseTable ["007"], encodeWords morseTable ["HI","THERE"]]

indexesToSplitOn :: Eq a => [a] -> [a] -> [Int]
indexesToSplitOn entireText phraseToSplitOn = [i | i <- [0.. length entireText - length phraseToSplitOn], isPrefixOf phraseToSplitOn (drop i entireText)]


splitGeneral :: Eq a => [a] -> [a] -> [[a]]
splitGeneral _ [] = [[]]
splitGeneral phraseToSplitOn entireText
        | phraseToSplitOn `isPrefixOf` entireText = [] : splitGeneral phraseToSplitOn (drop (length phraseToSplitOn) entireText)
        | otherwise =
            let 
                (y:ys) = entireText
                (first:rest) = splitGeneral phraseToSplitOn ys
            in (y:first):rest

splitSpecial :: Code -> [Code]
splitSpecial [] = []
splitSpecial entireText
    | dit `isPrefixOf` entireText = dit : splitSpecial (drop (length dit) entireText)
    | dah `isPrefixOf` entireText = dah : splitSpecial (drop (length dah) entireText)
    | mediumGap `isPrefixOf` entireText = [] : splitSpecial (drop (length mediumGap) entireText)  -- empty list indicates word boundary
    | shortGap `isPrefixOf` entireText = shortGap : splitSpecial (drop (length shortGap) entireText)        -- letter gap, skip it
    | otherwise = let (y:ys) = entireText in [y] : splitSpecial ys


stitchCodesToFormLetters :: [Code] -> [Code]
stitchCodesToFormLetters [] = []
stitchCodesToFormLetters (codeSymbolBeingFocusedOn:xs)
    | codeSymbolBeingFocusedOn == []        = [] : stitchCodesToFormLetters xs   -- This represents a empty list to signify a word 
                                                                                 -- seperator
    | codeSymbolBeingFocusedOn == shortGap  = stitchCodesToFormLetters xs     -- There's a shortGap between every code symbol and the next
                                                                              -- This simply skips that shortGap because we're tryna
                                                                              -- knit the codes of one character symbol together
    | otherwise      = stitchLetter [codeSymbolBeingFocusedOn] xs        -- This represents a code symbol part of a character symbol
  where
    stitchLetter currentCodeSymbol [] = [concat currentCodeSymbol]          
    stitchLetter currentCodeSymbol (y:ys)
        | y == shortGap = concat currentCodeSymbol : stitchCodesToFormLetters ys  
        | y == []       = concat currentCodeSymbol : [] : stitchCodesToFormLetters ys 
        | otherwise     = stitchLetter (currentCodeSymbol ++ [y]) ys 



encodeText :: Table -> String -> Code
encodeText table text = encodeWords table (splitGeneral " " text)



q1PartC :: [Code]
q1PartC = [encodeText morseTable "WORD", encodeText morseTable "HI THERE", encodeText morseTable "THIS IS A TEST"]



reversedTable :: Table -> [(Code, Char)]
reversedTable table = [ (code, character) | (character, code) <- table ]

decodeChar :: Table -> Code -> Char
decodeChar table code  = case lookup code (reversedTable table) of
    Just decodedValue -> decodedValue
    Nothing -> error ("The code was not found in the encoding table, so therefore has no decoded value to return")


-- (dit ++ shortGap ++ dah ++ mediumGap ++ dit ++ shortGap ++ dah)
prep :: Code -> [Code]
prep code  = stitchCodesToFormLetters (splitSpecial code)
decodeText :: Table -> Code -> String
decodeText table code =  [if character == [] then ' ' else decodeChar table character | character <- prep code]


data Tree = Empty
          | Branch (Maybe Char) Tree Tree
          deriving (Show , Eq)


getNode :: Tree -> [Code] -> Maybe Char
getNode Empty _ = Nothing
getNode (Branch val _ _) [] = val -- This val type is of type Maybe Char either Just Char or Nothing
getNode (Branch _ left right) (x:xs)
    | x == dit  = getNode left xs
    | x == dah  = getNode right xs
    | otherwise = Nothing

characterFromCode :: Tree -> [Code] -> Char
characterFromCode tree code = case getNode tree code of
    Just c  -> c
    Nothing -> error "Couldn't find character"

splitCodesIntoDitDah :: Code -> [Code]
splitCodesIntoDitDah [] = []
splitCodesIntoDitDah xs
    | dit `isPrefixOf` xs = dit : splitCodesIntoDitDah (drop (length dit) xs)
    | dah `isPrefixOf` xs = dah : splitCodesIntoDitDah (drop (length dah) xs)
    | otherwise = error "Invalid Morse code"

morseTree :: Tree
morseTree = Branch Nothing (Branch (Just 'E') (Branch (Just 'I') (Branch (Just 'S') (Branch (Just 'H') (Branch (Just '5') Empty Empty) (Branch (Just '4') Empty Empty)) (Branch (Just 'V') Empty (Branch (Just '3') Empty Empty))) (Branch (Just 'U') (Branch (Just 'F') Empty Empty) (Branch Nothing Empty (Branch (Just '2') Empty Empty)))) (Branch (Just 'A') (Branch (Just 'R') (Branch (Just 'L') Empty Empty) Empty) (Branch (Just 'W') (Branch (Just 'P') Empty Empty) (Branch (Just 'J') Empty (Branch (Just '1') Empty Empty))))) (Branch (Just 'T') (Branch (Just 'N') (Branch (Just 'D') (Branch (Just 'B') (Branch (Just '6') Empty Empty) Empty) (Branch (Just 'X') Empty Empty)) (Branch (Just 'K') (Branch (Just 'C') Empty Empty) (Branch (Just 'Y') Empty Empty))) (Branch (Just 'M') (Branch (Just 'G') (Branch (Just 'Z') (Branch (Just '7') Empty Empty) Empty) (Branch (Just 'Q') Empty Empty)) (Branch (Just 'O') (Branch Nothing (Branch (Just '8') Empty Empty) Empty) (Branch Nothing (Branch (Just '9') Empty Empty) (Branch (Just '0') Empty Empty)))))

convertThenCall :: Tree -> Code -> Char
convertThenCall treeConfiguration character = characterFromCode treeConfiguration ( splitCodesIntoDitDah character)

decodeTextWithTree :: Tree -> Code -> [Char]
decodeTextWithTree treeConfiguration code = [if character == [] then ' ' else convertThenCall treeConfiguration character | character <- prep code]



insertNode :: Tree -> Code -> Char -> Tree
insertNode Empty [] c = Branch (Just c) Empty Empty
insertNode Empty code c
    | dit `isPrefixOf` code  = Branch Nothing (insertNode Empty (drop (length dit)code) c) Empty
    | dah `isPrefixOf` code  = Branch Nothing Empty (insertNode Empty (drop (length dah)code) c)
    | otherwise = error "Invalid code in path"
insertNode (Branch _ left right) [] c = Branch (Just c) left right
insertNode (Branch val left right) code c
    | dit `isPrefixOf` code  = Branch val (insertNode left (drop (length dit)code) c) right
    | dah `isPrefixOf` code  = Branch val left (insertNode right (drop (length dah)code) c)
    | otherwise = error "Invalid code in path"


buildTree :: Tree -> [(Char,Code)] -> Tree
buildTree tree [] = tree
buildTree tree ((character,path):rest) = 
    let newTree = insertNode tree path character
    in buildTree newTree rest

builtTreeFromTable :: [(Char,Code)] -> Tree
builtTreeFromTable pathCharPairs = buildTree Empty pathCharPairs


-- Beep,Beep,Beep,Silence,Beep,Silence,Beep,Beep,Beep,Silence
ramify :: Table -> Tree
ramify table = builtTreeFromTable table


-- So ths one is given a tree produce the table. basically the exact opposite of what i just did. could potentially
-- use the getNode thing. But I also have to make a getPath tracker as well


bfsSkipFound :: Tree -> [Char] -> Maybe (Char, Code)
bfsSkipFound tree found = go [(tree, [])]
  where
    go [] = Nothing
    go ((Empty, _):xs) = go xs
    go ((Branch Nothing l r, path):xs) =
      go (xs ++ [(l, path ++ dit), (r, path ++ dah)])
    go ((Branch (Just val) l r, path):xs)
      | val `elem` found = go (xs ++ [(l, path ++ dit), (r, path ++ dah)])
      | otherwise        = Just (val, path)


formAllPathCharPairs :: Tree -> [(Char,Code)] -> [(Char,Code)]
formAllPathCharPairs tree foundPairs = 
    case bfsSkipFound tree foundChars of
        Just (val,path) -> 
            let newFoundPairs = foundPairs ++ [(val,path)]
            in formAllPathCharPairs tree newFoundPairs
        Nothing -> foundPairs
    where 
        foundChars = [v| (v,_) <- foundPairs]
        
tabulate :: Tree -> Table
tabulate tree = formAllPathCharPairs tree []


data Bracket = Round [Bracket] | Curly [Bracket] deriving (Show,Eq)
brackets :: Bracket -> String
brackets (Round ts) = "(" ++ concat [brackets t | t <- ts] ++ ")"
brackets (Curly ts) = "{" ++ concat [brackets t | t <- ts] ++ "}"

-- This works because <- if it returns Nothing breaks and ends the function with Nothing
searching :: Char -> Char -> String -> Maybe Int
searching opening closing string = searchForCharacter 0 0 string
  where
    searchForCharacter _ _ [] = Nothing
    searchForCharacter 0 i (x:xs)
      | x == closing = Just i
      | x == opening  = searchForCharacter 1 (i+1) xs
      | otherwise  = searchForCharacter 0 (i+1) xs
    searchForCharacter n i (x:xs)
      | x == opening  = searchForCharacter (n+1) (i+1) xs
      | x == closing = searchForCharacter (n-1) (i+1) xs
      | otherwise  = searchForCharacter n (i+1) xs

tree :: String -> Maybe Bracket
tree [] = Nothing
tree ['{','}'] = Just(Curly[])
tree ['(',')'] = Just(Round[])
tree (x:xs)
    | x == '(' = do
        index <- searching '(' ')' xs
        let beforeValue = take index xs
        children <- parseChildren beforeValue
        return (Round children)
    | x == '{' = do
        index <- searching '{' '}' xs
        let beforeValue = take index xs
        children <- parseChildren beforeValue
        return (Curly children)
    | otherwise = Nothing

parseChildren :: String -> Maybe [Bracket]
parseChildren "" = Just []
parseChildren s = do
    x <- tree s
    let nextPart = drop (length (brackets x)) s
    xs <- parseChildren nextPart
    return (x : xs)


isWellBracketed :: String -> Bool
isWellBracketed xs = case tree xs of
                      Nothing -> False
                      Just _  -> True
 


main :: IO()
main = print (tabulate morseTree)



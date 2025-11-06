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

splitLettersIntoDitDah :: Code -> [Code]
splitLettersIntoDitDah [] = []
splitLettersIntoDitDah xs
    | dit `isPrefixOf` xs = dit : splitLettersIntoDitDah (drop (length dit) xs)
    | dah `isPrefixOf` xs = dah : splitLettersIntoDitDah (drop (length dah) xs)
    | otherwise = error "Invalid Morse code"

morseTree :: Tree
morseTree = Branch Nothing (Branch (Just 'E') (Branch (Just 'I') (Branch (Just 'S') (Branch (Just 'H') (Branch (Just '5') Empty Empty) (Branch (Just '4') Empty Empty)) (Branch (Just 'V') Empty (Branch (Just '3') Empty Empty))) (Branch (Just 'U') (Branch (Just 'F') Empty Empty) (Branch Nothing Empty (Branch (Just '2') Empty Empty)))) (Branch (Just 'A') (Branch (Just 'R') (Branch (Just 'L') Empty Empty) Empty) (Branch (Just 'W') (Branch (Just 'P') Empty Empty) (Branch (Just 'J') Empty (Branch (Just '1') Empty Empty))))) (Branch (Just 'T') (Branch (Just 'N') (Branch (Just 'D') (Branch (Just 'B') (Branch (Just '6') Empty Empty) Empty) (Branch (Just 'X') Empty Empty)) (Branch (Just 'K') (Branch (Just 'C') Empty Empty) (Branch (Just 'Y') Empty Empty))) (Branch (Just 'M') (Branch (Just 'G') (Branch (Just 'Z') (Branch (Just '7') Empty Empty) Empty) (Branch (Just 'Q') Empty Empty)) (Branch (Just 'O') (Branch Nothing (Branch (Just '8') Empty Empty) Empty) (Branch Nothing (Branch (Just '9') Empty Empty) (Branch (Just '0') Empty Empty)))))

convertThenCall :: Tree -> Code -> Char
convertThenCall treeConfiguration character = characterFromCode treeConfiguration ( splitLettersIntoDitDah character)

decodeTextWithTree :: Tree -> Code -> [Char]
decodeTextWithTree treeConfiguration code = [if character == [] then ' ' else convertThenCall treeConfiguration character | character <- prep code]


module ParsingarthmeticExp where
import DerivedPrimitives
import Control.Applicative
import MonadicParsing
import Data.Char
expr :: Parser Int
expr = do t <- term
          do symbol "+"
             e <- expr
             pure (t + e)
           <|> pure t

term :: Parser Int
term = do f <- factor
          do symbol "*"
             t <- term
             pure (f * t)
           <|> pure f

factor :: Parser Int
factor = do symbol "("
            e <- expr
            symbol ")"
            pure e
          <|> natural

eval :: String -> Int
eval xs = case parse expr xs of
             [(n,[])]  -> n
             [(_,out)] -> error ("Unused input " ++ out)
             []        -> error "Invalid input"


module DerivedPrimitives where
import Control.Applicative
import MonadicParsing
import Data.Char


sat :: (Char -> Bool) -> Parser Char
sat p = do x <- item
           if p x then pure x else empty

digit :: Parser Char
digit = sat isDigit

lower :: Parser Char
lower = sat isLower

upper :: Parser Char
upper = sat isUpper

letter :: Parser Char
letter = sat isAlpha

alphanum :: Parser Char
alphanum = sat isAlphaNum

char :: Char -> Parser Char
char x = sat (==x)

string :: String -> Parser String
string []         = pure []
string (x:xs)     = do char x
                       string xs
                       pure (x:xs)

ident :: Parser String
ident = do x <- lower
           xs <- many alphanum
           pure (x:xs)

nat :: Parser Int
nat = do xs <- some digit
         pure (read xs)

space :: Parser ()
space = do many (sat isSpace)
           pure ()

int :: Parser Int
int = do char '-'
         n <- nat
         pure (-n)
      <|> nat

token :: Parser a -> Parser a
token p = do space
             v <- p
             space
             pure v

identifier :: Parser String
identifier = token ident

natural :: Parser Int
natural = token nat

integer :: Parser Int
integer = token int

symbol :: String -> Parser String
symbol xs = token (string xs)

-- a parser for a non-empty list of natural numbers that ignores spacing
nats :: Parser [Int]
nats = do symbol "["
          n <- natural
          ns <- many (do symbol ","
                         natural)
          symbol "]"
          pure (n:ns)

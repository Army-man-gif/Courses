-- Question 1
{-
    Basic instances:
        Bool
        Char
        Int
        Ordering
        (Bounded a, Bounded b)
        ....
        (Bounded a, Bounded b, Bounded c, Bounded d, Bounded e,
          Bounded f, Bounded g, Bounded h, Bounded i, Bounded j, Bounded k,
          Bounded l, Bounded m, Bounded n, Bounded o)
        Word
        ()
-}

-- Question 2
{-
    Fractional extends the Num type class
        Defines:
            recip for reciprocal
            fromRational converts Rational type to a fraction
    Floating extends Fractional
        Defines:
            pi
            exp for exponential
            log for logarithm
            sqrt for square roots
            (**) for exponent
            logBase
            sin
            cos
            tan
            asin
            acos
            atan
            sinh
            cosh
            tanh
            asinh
            acosh
            atanh
    Integral extends Real and Enum classes
        Defines:
            quotRem for quotientRemainder
            divMod for divisorModulo
            toInteger for converting to an Integer
    Floating seems to be the best type for trignometric calculus because it has lots of trig calc functions already defined

-}

-- Question 3
{-
    1) The type class Enum defines the function enumFromTo
    2) 
        instance Enum Double -- Defined in `GHC.Internal.Float'
            
        instance Enum Float -- Defined in `GHC.Internal.Float'
        instance Enum Bool -- Defined in `GHC.Internal.Enum'
        instance Enum Char -- Defined in `GHC.Internal.Enum'
        instance Enum Int -- Defined in `GHC.Internal.Enum'
        instance Enum Integer -- Defined in `GHC.Internal.Enum'
        instance Enum Ordering -- Defined in `GHC.Internal.Enum'
        instance Enum a => Enum (Solo a) -- Defined in `GHC.Internal.Enum'
        instance Enum () -- Defined in `GHC.Internal.Enum'
        instance Enum Word -- Defined in `GHC.Internal.Enum'
-}
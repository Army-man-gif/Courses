import Data.Char
-- Programming example : Binary String Transmitter

import Data.Char
type Bit = Int
bin2int :: [Bit] -> Int
bin2int bits = sum [w*b | (w,b) <- zip weights bits]
               where weights = iterate (*2) 1

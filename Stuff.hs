add'' :: Bool -> (Bool -> Bool)
add'' x y = x && y

addOftheTrue :: Bool -> Bool
addOftheTrue = add'' True

what :: (Bool -> Bool) -> Bool
what f = undefined
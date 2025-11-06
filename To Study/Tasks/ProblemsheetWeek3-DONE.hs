instance Num [()] where
    fromInteger n = replicate (fromInteger n) ()

    xs + ys = xs ++ ys

    xy * ys = concat(replicate(length(xs) ys))

    xy - ys = take(length xs - length ys) xs

    negate _ = []

    abs xs = xs

    signum xs = if null xs then [] else [()]

import Data.Char (isLetter)

stripANSI :: String -> String
stripANSI [] = []
stripANSI ('\ESC':'[':xs) = stripANSI (drop 1 (dropWhile (not . isLetter) xs))
stripANSI (x:xs) = x : stripANSI xs

transpose :: [[a]] -> [[a]]
transpose [] = []
transpose ([]:_) = []
transpose x = map head x : transpose (map tail x)

visibleLength :: String -> Int
visibleLength = length . stripANSI


-- Record notation explanation so I remember:
    -- Ok so here the first "Grid" the one right after newtype is the box
    -- our custom type is the next "Grid". This is the actual function that is crafting our values
    -- the things inside the {} are the contents/the values. and this is assigned "grid" for easy access later on
        -- Enables easy conversion of a list of lists to a Grid type and a Grid type to a list of lists
            -- This is helpful because the Grid type can be converted to a list of lists, the list of lists modified
            -- then converted back to a Grid type, enabling the Grid to be changed without rewriting an entire newtype
            -- or instance again
newtype Grid a = Grid { grid :: [[a]] } deriving (Eq, Functor)

instance (Show a) => Show (Grid a) where
  show (Grid g)
    | null g = ""
      -- unline concatenates each element in the list with a newline between each element
    | otherwise = unlines (map showRow g)
    where
      strGrid = map (map show) g
      colWidths = [maximum (map visibleLength col) | col <- transpose strGrid]
      -- unwords concatenates each element in the list with a space between each element
      showRow row = unwords [padRight w s | (w, s) <- zip colWidths (map show row)]
      padRight n s = s ++ replicate (n - visibleLength s) ' '

-- Task 1

newtype GridWithAPointer a = GridWithAPointer (Grid a, [a], a, [a], Grid a)
instance (Show a, Eq a) => Show (GridWithAPointer a) where
     show (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow))
        | all null (grid gridAbove) && all null (grid gridBelow) && null elementsToLeftreversed && null elementsToRight = ""
        | otherwise = unlines[ showRow index row | (index,row) <- zip [0..] builtGrid]
        where
            createTheListFortheRowofTheFocusedElement = reverse elementsToLeftreversed ++ [elementToFocus] ++ elementsToRight
            builtGrid  = filter (not . null) (grid gridAbove) ++ [createTheListFortheRowofTheFocusedElement] ++ filter (not . null) (grid gridBelow)
            strGrid = map (map show) builtGrid
            colWidths = [maximum     (map visibleLength col) | col <- transpose strGrid]
            customRowDisplaying indexOfRow row indexToStopAt= [
                if 
                    element == elementToFocus && index == indexToStopAt && indexOfRow == length ((filter (not . null) (grid gridAbove)))
                then 
                    "\ESC[44m" ++ show element ++ "\ESC[0m" 
                else 
                    show element 
                | (index,element) <- zip [0..] row ]
            lengthOfleft = length elementsToLeftreversed
            -- unwords concatenates each element in the list with a space between each element
            showRow indexOfRow row = unwords [padRight w s | (w, s) <- zip colWidths (customRowDisplaying indexOfRow row lengthOfleft)]
            padRight n s = s ++ replicate (n - visibleLength s) ' '


put :: a -> GridWithAPointer a -> GridWithAPointer a
updateGrid :: a -> GridWithAPointer a -> GridWithAPointer a

updateGrid  value (GridWithAPointer(gridAbove,elementsToLeftreversed,_,elementsToRight,gridBelow)) = 
    GridWithAPointer(gridAbove,elementsToLeftreversed,value,elementsToRight,gridBelow)


-- Task 2

-- Movements
safeRowIndex :: [[a]] -> Int -> Maybe [a]
safeRowIndex rows i
  | i < length rows = Just(rows !! i)
  | otherwise       = Nothing

safeColIndex :: [a] -> Int -> Maybe a
safeColIndex row i
  | i < length row = Just (row !! i)
  | otherwise      = Nothing

moveLeft :: GridWithAPointer a -> GridWithAPointer a
moveLeft (GridWithAPointer(gridAbove,[],elementToFocus,elementsToRight,gridBelow)) = 
    GridWithAPointer(gridAbove,[],elementToFocus,elementsToRight,gridBelow)
moveLeft (GridWithAPointer(gridAbove,(x:xs),elementToFocus,elementsToRight,gridBelow)) = 
    let 
        newElementToFocus = x
        newElementsToLeftreversed = xs
        newElementsToRight = elementToFocus:elementsToRight
    in
        GridWithAPointer(gridAbove,newElementsToLeftreversed,newElementToFocus,newElementsToRight,gridBelow)

moveRight :: GridWithAPointer a -> GridWithAPointer a

moveRight (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,[],gridBelow)) = 
    GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,[],gridBelow)
moveRight (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,(x:xs),gridBelow)) = 
    let 
        newElementToFocus = x
        newElementsToRight = xs
        newElementsToLeftreversed = elementToFocus:elementsToLeftreversed
    in
        GridWithAPointer(gridAbove,newElementsToLeftreversed,newElementToFocus,newElementsToRight,gridBelow)

moveUp :: GridWithAPointer a -> GridWithAPointer a
moveUp (GridWithAPointer(Grid [[]],elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)) =
    GridWithAPointer(Grid [[]],elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)
moveUp (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)) =
    let 
        lengthOfLeftelements = length elementsToLeftreversed
        splice x start end = take(end - start)( drop(start) x )

        indexOfLastRowinAboveGrid = (length ((filter (not . null) (grid gridAbove)))) - 1 

        newCurrentRow = case safeRowIndex (grid gridBelow) indexOfLastRowinAboveGrid of
            Just row -> row
            Nothing  -> error "moveDown: no row to focus on"

        newElementToFocus = case safeColIndex newCurrentRow lengthOfLeftelements of
            Just x  -> x
            Nothing -> error "moveDown: row too short"
        newElementsToLeftreversed = reverse (splice (grid gridAbove !!(indexOfLastRowinAboveGrid)) 0 (lengthOfLeftelements))
        lengthOfNewCurrentRow =  length newCurrentRow
        newElementsToRight = splice (newCurrentRow) (lengthOfLeftelements+1) (lengthOfNewCurrentRow)

        newGridAbove = init (grid gridAbove)
        constructRowToAttachToBottomGrid = reverse elementsToLeftreversed ++ [elementToFocus] ++ elementsToRight
        newGridBelow = [constructRowToAttachToBottomGrid] ++ grid gridBelow
    in 
      GridWithAPointer(Grid newGridAbove,newElementsToLeftreversed,newElementToFocus,newElementsToRight,Grid newGridBelow)

moveDown :: GridWithAPointer a -> GridWithAPointer a
moveDown (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,Grid [[]])) =
    GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,Grid [[]])
moveDown (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)) =
    let 
        lengthOfLeftelements = length elementsToLeftreversed
        splice x start end = take(end - start)( drop(start) x )

        newCurrentRow = case safeRowIndex (grid gridBelow) 0 of
            Just row -> row
            Nothing  -> error "moveDown: no row to focus on"

        newElementToFocus = case safeColIndex newCurrentRow lengthOfLeftelements of
            Just x  -> x
            Nothing -> error "moveDown: row too short"
            
        newElementsToLeftreversed = reverse (splice (grid gridBelow !! 0 ) 0 (lengthOfLeftelements))
        lengthOfNewCurrentRow =  length newCurrentRow
        newElementsToRight = splice (newCurrentRow) (lengthOfLeftelements+1) (lengthOfNewCurrentRow)

        newGridBelow = tail (grid gridBelow)
        constructRowToAttachToTopGrid = reverse elementsToLeftreversed ++ [elementToFocus] ++ elementsToRight
        newGridAbove = grid gridAbove ++ [constructRowToAttachToTopGrid]
    in 
      GridWithAPointer(Grid newGridAbove,newElementsToLeftreversed,newElementToFocus,newElementsToRight,Grid newGridBelow)


put value grid = updateGrid value grid

-- Task 3

-- Copy logic for tatamis

copyValueUpwards :: GridWithAPointer a -> GridWithAPointer a
copyValueUpwards (GridWithAPointer(Grid [[]],elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)) =
    GridWithAPointer(Grid [[]],elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)
copyValueUpwards (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)) = 
    let 
        lengthOfLeftelements = length elementsToLeftreversed
        splice x start end = take(end - start)( drop(start) x )

        indexOfLastRowinAboveGrid = (length ((filter (not . null) (grid gridAbove)))) - 1 


        newElementToFocus = elementToFocus
        newElementsToLeftreversed = reverse (splice (grid gridAbove !!(indexOfLastRowinAboveGrid)) 0 (lengthOfLeftelements))
        newCurrentRow = case safeRowIndex (grid gridBelow) indexOfLastRowinAboveGrid of
            Just row -> row
            Nothing  -> error "moveDown: no row to focus on"
        
        lengthOfNewCurrentRow =  length newCurrentRow
        newElementsToRight = splice (newCurrentRow) (lengthOfLeftelements+1) (lengthOfNewCurrentRow)

        newGridAbove = init (grid gridAbove)
        constructRowToAttachToBottomGrid = reverse elementsToLeftreversed ++ [elementToFocus] ++ elementsToRight
        newGridBelow = [constructRowToAttachToBottomGrid] ++ grid gridBelow
    in 
      GridWithAPointer(Grid newGridAbove,newElementsToLeftreversed,newElementToFocus,newElementsToRight,Grid newGridBelow)


copyValueDownwards :: GridWithAPointer a -> GridWithAPointer a
copyValueDownwards (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,Grid [[]])) =
    GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,Grid [[]])
copyValueDownwards (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)) = 
    let 
        lengthOfLeftelements = length elementsToLeftreversed
        splice x start end = take(end - start)( drop(start) x )


        newElementToFocus = elementToFocus
        newElementsToLeftreversed = reverse (splice (grid gridBelow !! 0 ) 0 (lengthOfLeftelements))
        newCurrentRow = case safeRowIndex (grid gridBelow) 0 of
            Just row -> row
            Nothing  -> error "moveDown: no row to focus on"
        lengthOfNewCurrentRow =  length newCurrentRow
        newElementsToRight = splice (newCurrentRow) (lengthOfLeftelements+1) (lengthOfNewCurrentRow)

        newGridBelow = tail (grid gridBelow)
        constructRowToAttachToTopGrid = reverse elementsToLeftreversed ++ [elementToFocus] ++ elementsToRight
        newGridAbove = grid gridAbove ++ [constructRowToAttachToTopGrid]
    in 
      GridWithAPointer(Grid newGridAbove,newElementsToLeftreversed,newElementToFocus,newElementsToRight,Grid newGridBelow)


copyValueRight :: GridWithAPointer a -> GridWithAPointer a
copyValueRight (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,[],gridBelow)) = 
    GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,[],gridBelow)
copyValueRight (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,(x:xs),gridBelow)) = 
    let 
        newElementToFocus = elementToFocus
        newElementsToRight = elementToFocus:xs
    in
        GridWithAPointer(gridAbove,elementsToLeftreversed,newElementToFocus,newElementsToRight,gridBelow)

copyValueLeft :: GridWithAPointer a -> GridWithAPointer a
copyValueLeft (GridWithAPointer(gridAbove,[],elementToFocus,elementsToRight,gridBelow)) = 
    GridWithAPointer(gridAbove,[],elementToFocus,elementsToRight,gridBelow)
copyValueLeft (GridWithAPointer(gridAbove,(x:xs),elementToFocus,elementsToRight,gridBelow)) = 
    let 
        newElementToFocus = elementToFocus
        newElementsToLeftreversed = elementToFocus:xs
    in
        GridWithAPointer(gridAbove,newElementsToLeftreversed,newElementToFocus,elementsToRight,gridBelow)

-- Tatami placing logic

putTatamiUp :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiUp value (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow))
    | all null (grid gridAbove) = GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)
    | otherwise = 
        let grid' = put value (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow))
            grid'' = copyValueUpwards grid'
        in moveDown grid''

putTatamiDown :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiDown value (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow))
    | all null (grid gridBelow)  = GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)
    | otherwise = 
        let grid' = put value (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow))
            grid'' = copyValueDownwards grid'
        in moveUp grid''

putTatamiRight :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiRight value (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow))
    | null elementsToRight = GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)
    | otherwise = 
        let grid' = put value (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow))
            grid'' = copyValueRight grid'
        in grid''

putTatamiLeft :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiLeft value (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow))
    | null elementsToLeftreversed = GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)
    | otherwise = 
        let grid' = put value (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow))
            grid'' = copyValueLeft grid'
        in grid''
-- Task 4


putTatamiUpStay :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiUpStay value (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow))
    | all null (grid gridAbove) = GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)
    | otherwise = 
        let grid' = put value (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow))
            grid'' = copyValueUpwards grid'
        in grid''

putTatamiDownStay :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiDownStay value (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow))
    | all null (grid gridBelow)  = GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)
    | otherwise = 
        let grid' = put value (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow))
            grid'' = copyValueDownwards grid'
        in grid''

putTatamiRightStay :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiRightStay value (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow))
    | null elementsToRight = GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)
    | otherwise = 
        let grid' = put value (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow))
            grid'' = copyValueRight grid'
        in moveRight grid''

putTatamiLeftStay :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiLeftStay value (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow))
    | null elementsToLeftreversed = GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)
    | otherwise = 
        let grid' = put value (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow))
            grid'' = copyValueLeft grid'
        in moveLeft grid''


empty = GridWithAPointer(Grid [[0,0,0,0]],[],0,[0,0,0], Grid [[0,0,0,0]])

result = (putTatamiRightStay 6 . moveRight . putTatamiRightStay 5) empty
GridWithAPointer(gridAbove',elementsToLeftreversed',elementToFocus',elementsToRight',gridBelow') = result
current = elementToFocus'

{-
    For EACH possible direction:
        1. Place tatami
        2. RECURSE (try to solve the REST of the grid)
        3. If recursion returns success → bubble up success!
        4. If recursion returns failure → UNDO and try next direction
    
    4 possible directions each time
    Constraints:
        Must be within grid boundaries
        Another tatami nor part of a tatami cannot
        have alr been placed on the one you're placing on
        In any 2x2 there can't be 4 unique numbers
-}
cover :: GridWithAPointer Integer -> GridWithAPointer Integer
cover grid = 
    case tryToCoverGridWithCurrentDecision Vertical grid 1 of
        Just solution -> solution
        Nothing -> error "Impossible to cover this grid in tatamis"

-- Helper functions part 1
isFullyCovered :: GridWithAPointer Integer -> Bool
isFullyCovered (GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)) = 
    let 
        currentRow = reverse elementsToLeftreversed ++ [elementToFocus] ++ elementsToRight
        entireGrid = grid gridAbove ++ [currentRow] ++ grid gridBelow

    in
        not ( any (elem 0) entireGrid)

data Orientation = Vertical | Horizontal

movePointerToNextEmptyCell :: Orientation -> GridWithAPointer Integer -> GridWithAPointer Integer
movePointerToNextEmptyCell orientation gridAlias@(GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)) = 
    let 
        currentRow = reverse elementsToLeftreversed ++ [elementToFocus] ++ elementsToRight
        indexOfCurrentRow = length ((filter (not . null) (grid gridAbove)))
        lengthOfCurrentRow = length currentRow
        indexOfElementToFocusOnItsRow  = length elementsToLeftreversed
        entireGrid = grid gridAbove ++ [currentRow] ++ grid gridBelow
        entireGridLength = length ((filter (not . null) (entireGrid)))
        elementJustBelow = 
            if indexOfCurrentRow == (entireGridLength - 1)
            then -1
            else
                (entireGrid !! (indexOfCurrentRow + 1)) !! indexOfElementToFocusOnItsRow
        elementJustRight = 
            if indexOfElementToFocusOnItsRow == (lengthOfCurrentRow - 1)
            then -1
            else
                (entireGrid !! indexOfCurrentRow) !! (indexOfElementToFocusOnItsRow + 1)
        elementJustAbove = 
            if indexOfCurrentRow == 0
            then -1
            else 
                (entireGrid !! (indexOfCurrentRow -1)) !! indexOfElementToFocusOnItsRow
        elementJustLeft = 
            if indexOfElementToFocusOnItsRow == 0
            then -1
            else
                (entireGrid !! indexOfCurrentRow) !! (indexOfElementToFocusOnItsRow -1)
        -- Look around the elementToFocus in this order: Up, Left, Down, Right for vertical and
        -- left, up, right, down for horizontal
        newGrid = case orientation of 
            Vertical -> 
                if elementJustAbove == 0 then moveUp gridAlias
                else if elementJustLeft == 0 then moveLeft gridAlias
                else if elementJustBelow == 0 then moveDown gridAlias
                else if elementJustRight == 0 then moveRight gridAlias
                else gridAlias
            Horizontal ->
                if elementJustLeft == 0 then moveLeft gridAlias
                else if elementJustAbove == 0 then moveUp gridAlias
                else if elementJustRight == 0 then moveRight gridAlias
                else if elementJustBelow == 0 then moveDown gridAlias
                else gridAlias
        in
            newGrid                



-- Helper functions part 2
tryPlacingUp :: GridWithAPointer Integer -> Integer -> Maybe (GridWithAPointer Integer)
tryPlacingUp  grid tatamiNumber= 
    if canPlaceUp grid then
        let 
            gridAfterTatamiisPlaced = putTatamiUpStay tatamiNumber grid
            attemptDirection = tryToCoverGridWithCurrentDecision Vertical gridAfterTatamiisPlaced (tatamiNumber + 1)
        in case attemptDirection of
            Just solution -> Just solution
            Nothing -> 
                tryPlacingDown grid tatamiNumber
    else
        tryPlacingDown grid tatamiNumber



tryPlacingDown :: GridWithAPointer Integer -> Integer -> Maybe (GridWithAPointer Integer)
tryPlacingDown  grid tatamiNumber= 
    if canPlaceDown grid then
        let 
            gridAfterTatamiisPlaced = putTatamiDownStay tatamiNumber grid
            attemptDirection = tryToCoverGridWithCurrentDecision Vertical gridAfterTatamiisPlaced (tatamiNumber + 1)
        in case attemptDirection of
            Just solution -> Just solution
            Nothing -> 
                tryPlacingLeft grid tatamiNumber
    else
        tryPlacingLeft grid tatamiNumber


tryPlacingLeft :: GridWithAPointer Integer -> Integer -> Maybe (GridWithAPointer Integer)
tryPlacingLeft  grid tatamiNumber= 
    if canPlaceLeft grid then
        let 
            gridAfterTatamiisPlaced = putTatamiLeftStay tatamiNumber grid
            attemptDirection = tryToCoverGridWithCurrentDecision Horizontal gridAfterTatamiisPlaced (tatamiNumber + 1)
        in case attemptDirection of
            Just solution -> Just solution
            Nothing -> 
                tryPlacingRight grid tatamiNumber
    else
        tryPlacingRight grid tatamiNumber


tryPlacingRight :: GridWithAPointer Integer -> Integer -> Maybe (GridWithAPointer Integer)
tryPlacingRight  grid tatamiNumber= 
    if canPlaceRight grid then
        let 
            gridAfterTatamiisPlaced = putTatamiRightStay tatamiNumber grid
            attemptDirection = tryToCoverGridWithCurrentDecision Horizontal gridAfterTatamiisPlaced (tatamiNumber + 1)
        in case attemptDirection of
            Just solution -> Just solution
            Nothing -> Nothing
    else
        Nothing

allUnique :: Eq a => [a] -> Bool
allUnique []     = True
allUnique (x:xs) = not (x `elem` xs) && allUnique xs

doesItSatisfyNoQuadTatamiShareConstraint :: GridWithAPointer Integer -> Bool
doesItSatisfyNoQuadTatamiShareConstraint gridAlias@(GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)) = 
    let 
        currentRow = reverse elementsToLeftreversed ++ [elementToFocus] ++ elementsToRight
        indexOfCurrentRow = length ((filter (not . null) (grid gridAbove)))
        lengthOfCurrentRow = length currentRow
        indexOfElementToFocusOnItsRow  = length elementsToLeftreversed
        entireGrid = grid gridAbove ++ [currentRow] ++ grid gridBelow
        entireGridLength = length ((filter (not . null) (entireGrid)))
        getValue row column
            | row < 0 || row >= entireGridLength = -1
            | column < 0 || column >= lengthOfCurrentRow = -1
            | otherwise  = entireGrid !! row !! column
        
        -- Calcuating all 4 sitautions dynamically: vlaue is at top-left;bottom-left;top-right;bottom-right
        allPossibleSquares = 
            [ [ getValue (topLeftCornerRow + r) (topLeftCornerColumn + c)
                | r <- [0,1]
                , c <- [0,1]
                ]
            | topLeftCornerRowAdjust <- [-1,0]
            , topLeftCornerColAdjust <- [-1,0]
            , let topLeftCornerRow = indexOfCurrentRow + topLeftCornerRowAdjust
            , let topLeftCornerColumn = indexOfElementToFocusOnItsRow + topLeftCornerColAdjust
            , topLeftCornerRow >= 0
            , topLeftCornerRow + 1 < entireGridLength
            , topLeftCornerColumn >= 0
            , topLeftCornerColumn + 1 < lengthOfCurrentRow
            ]
    in
        not (any (\b -> allUnique b) allPossibleSquares)



canPlaceUp :: GridWithAPointer Integer -> Bool
canPlaceUp gridAlias@(GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)) = 
    let 
        currentRow = reverse elementsToLeftreversed ++ [elementToFocus] ++ elementsToRight
        indexOfCurrentRow = length ((filter (not . null) (grid gridAbove)))
    in
        if indexOfCurrentRow == 0
            then False
        else if not(doesItSatisfyNoQuadTatamiShareConstraint gridAlias)
            then False
        else True

canPlaceDown :: GridWithAPointer Integer -> Bool
canPlaceDown gridAlias@(GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)) = 
    let 
        currentRow = reverse elementsToLeftreversed ++ [elementToFocus] ++ elementsToRight
        indexOfCurrentRow = length ((filter (not . null) (grid gridAbove)))
        entireGrid = grid gridAbove ++ [currentRow] ++ grid gridBelow
        entireGridLength = length ((filter (not . null) (entireGrid)))

    in
        if indexOfCurrentRow == (entireGridLength - 1)
            then False
        else if not(doesItSatisfyNoQuadTatamiShareConstraint gridAlias)
            then False
        else True

canPlaceLeft :: GridWithAPointer Integer -> Bool
canPlaceLeft gridAlias@(GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)) = 
    let 
        currentRow = reverse elementsToLeftreversed ++ [elementToFocus] ++ elementsToRight
        indexOfElementToFocusOnItsRow  = length elementsToLeftreversed

    in
        if indexOfElementToFocusOnItsRow == 0
            then False
        else if not(doesItSatisfyNoQuadTatamiShareConstraint gridAlias)
            then False
        else True
canPlaceRight :: GridWithAPointer Integer -> Bool
canPlaceRight gridAlias@(GridWithAPointer(gridAbove,elementsToLeftreversed,elementToFocus,elementsToRight,gridBelow)) = 
    let 
        currentRow = reverse elementsToLeftreversed ++ [elementToFocus] ++ elementsToRight
        lengthOfCurrentRow = length currentRow
        indexOfElementToFocusOnItsRow  = length elementsToLeftreversed

    in
        if indexOfElementToFocusOnItsRow == (lengthOfCurrentRow - 1)
            then False
        else if not(doesItSatisfyNoQuadTatamiShareConstraint gridAlias)
            then False
        else True

tryToCoverGridWithCurrentDecision :: Orientation -> GridWithAPointer Integer -> Integer -> Maybe(GridWithAPointer Integer)
tryToCoverGridWithCurrentDecision orientation grid tatamiNumber = 
    if isFullyCovered grid then
        Just grid
    else
        let gridWithPointerMoved = movePointerToNextEmptyCell orientation grid
        in tryPlacingUp gridWithPointerMoved tatamiNumber

variable = GridWithAPointer( Grid [[]], [],0,[0,0,0],Grid [[0,0,0,0],[0,0,0,0],[0,0,0,0]] )
final  = cover variable
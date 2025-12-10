import Control.Concurrent

-- Defines a "custom type" name made of basic type in a data structure
-- This is so the "custom type" name can be used to indicate that custom structure instead of rewriting the structure
type Cell = (Int,Int)
type Grid = [Cell]
-- This simply defines two variables. First part defines the type and second part defines the value
-- It's simply setting up the coordinates of the live cells
pentagenarian :: Grid
pentagenarian = [(1,2),(2,2),(2,3),(4,1),(4,3)]

glider :: Grid
glider = [(1,3),(2,1),(2,3),(3,2),(3,3)]

-- Ok so here is a chained definition
-- The first line says that given a Cell it return a function that "given a function I will tell you if that Cell you gave is alive or not
-- Then the next two lines define the functions in that type format
-- It gives a cell and grid to return alive or not
-- The advantage of the chain is that it can be partially called and finished later
-- Like for example (2,3) as a Cell can be defined then different grids [(2,3),(4,5)] or [(5,6),(6,7)] can be iterated over that returned function
isLive, isDead :: Cell -> (Grid -> Bool)
isLive c g = c `elem` g
isDead c g = not (isLive c g)

-- Simple type definition. Takes a Cell as an arguement and return a list of Cells
neighbours :: Cell -> [Cell]
-- So remember this below value definition MUST take ONE Cell as an arugment and return a list of Cells
-- So this is a list comprehension line
-- It's a shorthand version of a for loop
-- [expression | generator1, generator2, ... , filter1, filter 2, ... ]
-- "expression" is what the variable is being used IN the body of the loop and saved as the list if itereated through
-- "generators" are the boundaries
    -- variables <- list
    -- so i in the list [-1..1] and j in the list [-1..1] 
        -- [-1..1] means -1 through to 1
-- and lastly "filters" are specific conditions that say what to exclude or include
-- You can tell where the generators end and filters start bc generators have this syntax
    -- variables <- list
neighbours (x,y) = [ (x+i,y+j) | i <- [-1..1], j <- [-1..1], not (i==0 && j==0) ]

-- Simple type chained definition again. Grid arguemnt given and a function " Cell -> [Cell]" returned
-- Then Cell arguement given and list of Cells returned
liveNeighbours :: Grid -> Cell -> [Cell]
-- Okay so this is the same list comprehension format as 'neighbours'
-- So this means we have c in the body of the for loop
-- And taking each element in the list of Cells returned by 'neighbours' when given the Cell we're on right now
-- We keep the ones that are live based on our current cell and the grid
liveNeighbours g c = [c' | c' <- neighbours c, isLive c' g]

-- Ok so a simply type definition again
-- A Grid argument and returns a Grid
step :: Grid -> Grid
-- Self explanatory
    -- An empty list is technically still a list of Cells
step [] = []
-- Ok so a big complex definition using our customly defined type
-- Ok so a list comprehension again + a where add-on
    -- The bit before the where is the main “body” of the function.
    -- The bit after where is a set of custom helper definitions (variables or even mini-functions) with names you choose.
    -- Those helpers are then used up above, in the body of the function.
-- Ok so it is using (x,y) tuple inside the for loop
-- We have two generators { Which remember define what the expression variables are}
    -- x is a list of 
        -- "the value of the custom helper function 'minX' -1" to "the value of the custom helper function 'maxX' + 1"
    -- y is a list of 
        -- "the value of the custom helper function 'minY' -1" to "the value of the custom helper function 'maxY' + 1"
-- Ok now we have our filters
    -- now remember we have defined isDead and isLive already
        -- Ok now the two conditions in our filter is
            -- The Cell is dead AND the number of elements in the liveNeighbours Cells array is 3
            -- The Cell is alive AND the number of elements in the liveNeighbours Cells array is either 2 or 3
        -- Now only one of these two conditions NEED to be fufilled. Obviously both can be fufilled
        -- If one fufilled include in next grid, which means either stay alive or come back alive

step g =
  [(x,y) | x <- [minX-1 .. maxX+1],
           y <- [minY-1 .. maxY+1],
              (isDead (x,y) g && length (liveNeighbours g (x,y)) == 3)
           || (isLive (x,y) g && length (liveNeighbours g (x,y)) `elem` [2,3])
         ]
-- Lastly we have the custom helper definitions
    -- minX
        -- Take all the cells (x,y) in the grid and only keep the x values
        -- Keep all these x values in a list
        -- Find the minimum of this list
    -- maxX
        -- Take all the cells (x,y) in the grid and only keep the x values
        -- Keep all these x values in a list
        -- Find the maximum of this list
    -- minY
        -- Take all the cells (x,y) in the grid and only keep the x values
        -- Keep all these y values in a list
        -- Find the minimum of this list
    -- maxY
        -- Take all the cells (x,y) in the grid and only keep the x values
        -- Keep all these y values in a list
        -- Find the maximum of this list
  where
    minX = minimum [ x | (x,y) <- g ]
    maxX = maximum [ x | (x,y) <- g ]
    minY = minimum [ y | (x,y) <- g ]
    maxY = maximum [ y | (x,y) <- g ]

-- Just variables defining size of drawing area

terminalWidth  = 70
terminalHeight = 22

-- Syntax: IO () means “an action in the real world that returns nothing”
cls :: IO ()
-- Logic: Clears the screen using an ANSI escape code
cls = putStr "\ESC[2J"
-- Syntax: String concatenation in Haskell is ++
goto :: Cell -> IO ()
-- Custom ANSI cursor movement
-- So the string built is:
-- E.G: "\ESC[19;3H"
-- This tells the terminal:
-- 👉 “Move cursor to row 19, column 3.”
-- DEFINES the movement command
-- 'show' converts a number into a string.
goto (x,y) = putStr ("\ESC[" ++ show (terminalHeight-y) ++ ";" ++ show (x+1) ++ "H")

-- Defines the print each cell command
    -- If the Cell coordinate is not off the screen
        -- So in x and y direction more than or equal to 0 and less than the height or width of terminal
    -- If it isn't off the screen goto that Cell coordinate and write a string '0' there
    -- If it is off the screen do nothing
printCell :: Cell -> IO ()
printCell (x,y) | x >= 0 && x < terminalWidth
               && y >= 0 && y < terminalHeight = do
                                                  goto (x,y)
                                                  putChar 'O'

                | otherwise                    = return ()
-- Defines the render command
    -- the 'do' command chains IO() actions
        -- clear screen
        -- call 'printCell' on each cell in grid
        -- call 'goto' passing in the height of the terminal defined earlier to move it to the bottom of the page so it
        -- resets for each cell so each cell moves to the right location with the 'goto' that's called in 'printCell'
terminalRender :: Grid -> IO ()
terminalRender g = do
                    cls
                    sequence [ printCell c | c <- g ]
                    goto (0,terminalHeight)
-- Defines delay command
-- threadDelay reads it's input in microseconds
    -- So one microsecond times 100,000 = 0.1 seconds
    -- Then times 'n'
    -- So it's n tenths of a seconds
delayTenthSec :: Int -> IO ()
delayTenthSec n = threadDelay (n * 10^5)
-- Defines the life function
-- Defines seed, which takes the custom helper function f, generation number and grid
life :: Grid -> IO ()
life seed = f 0 seed
-- It does a sequences of things
    -- Calls 'terminalRender' which clears the screen and draws the current grid of '0's
    -- Prints the current generation number
    -- Delays by one tenth of a second
    -- Recurses by adding one to n and passing the new grid based on the current grid cells values and neighbours
    -- It recurses forever because there is no base case
 where
  f n g = do
           terminalRender g
           putStrLn (show n)
           delayTenthSec 1
           f (n+1) (step g)

-- Calls the life definition with the glider list of Cells defines at top
main :: IO ()
main = life glider

-- Just alternative grids
block3 :: Grid
block3 = [(x,y) | x <- [1..3], y <- [1..3]]

pulsar :: Grid
pulsar = [(x+i,y) | x <- [2,8], y <- [0,5,7,12], i <- [0..2]] ++ [(x,y+i) | x <- [0,5,7,12], y <- [2,8], i <- [0..2]]


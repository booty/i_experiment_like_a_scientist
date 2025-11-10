# Knight's Tour

## Algorithm

- Define a board and a starting position for the knight
  - Board is assumed to be square
- Push the knight's current location onto the stack
- Mark the current location with the move number
- Did we win?
  - Win condition: @location_history.length == board_size \*\* 2
  - This should work for the degenerate case (a 1x1 board)
- Determine a list of valid moves. For each of the 8 possible movements,
  - Discard moves that are out of bounds
  - Discard moves that revisit a previously visited square
- If there are valid moves, choose one (random or static)
  - Push the new location onto the stack
  - Push the list of possible moves onto the stack, minus the one that was chosen
- If there are no valid moves
  - Pop the possible moves from the stack
  - Pop the knight's previous position from the stack

## Classes / Structures

- Point
  - @x
  - @y
- Board
  - 2d array, initialized to nils
  - Each square contains
    - nil (the knight hasn't visited yet)
    - a number (the knight visited as part of his tour)
    - an "X" (the knight visited, but reached a dead and and had to backtrack)
- Game
  - @board (Board)
    - this is the knight's current location
  - @location_history
    - a stack of the knight's previous moves
  - current_location()
    - basically, an alias for @location_history.last
  - move_number()
    - basically, an alias for @location_history.length
  -

# frozen_string_literal: true

# Eight Queens
#
# This kata is based on the classic chess rules. You
# must put eight chess queens on an 8×8 chessboard
# such that none of them is able to capture any other
# using the standard chess queen’s moves.
#
# A queen can move any number of squares in one of these directions:
#	1.	Horizontal — same row
#	2.	Vertical — same column
#	3.	Diagonal — both diagonals
#
# A capture is possible if:
# 1. The target queen lies in one of those directions, and
# 2. There is no other piece between them along that line.

NEW_BOARD = lambda { |board_size: 8|
  Array.new(board_size) { Array.new(board_size) }
}



def find_next_square(board:, queens:, invalid_squares:)
	max = board.length - 1
	0.upto(max) do |y|
		# are there any queens on this row? if so, next
		0.upto(max) do |x|
			# any queens in this column? if so, next

			# iterate over the row, skipping any invalid moves we've already tried

			# if we found a solution, exit early
		end
	end
end



def queens(board_size: 8)
  queens = []
  invalid_squares = []
  board = NEW_BOARD.call

  while queens.length < 8
    next_square = find_next_square(board:, queens:, invalid_squares:)

		# if find_next_square returned nil, we need to backtrack   end
end

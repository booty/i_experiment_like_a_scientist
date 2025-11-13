# frozen_string_literal: true

VERBOSE = true

puts "Hello, from Knight III... ✌️"

Point = Data.define(:x, :y) do
  def +(other)
    Point.new(x + other.x, y + other.y)
  end

  def to_s
    "Point(#{x},#{y})"
  end

  def inspect
    to_s
  end
end

DELTAS = [
  Point.new(x: 2, y: 1),
  Point.new(x: 2, y: -1),
  Point.new(x: -2, y: 1),
  Point.new(x: -2, y: -1),
  Point.new(x: 1, y: 2),
  Point.new(x: 1, y: -2),
  Point.new(x: -1, y: 2),
  Point.new(x: -1, y: -2)
].freeze

# The heuristic here is: choose the move with the lowest number of possible resulting moves
# returns [[move, score], ...]
def legal_moves_with_scores(board:, position:, recurse:)
  moves = []
  DELTAS.each do |delta|
    new_position = position + delta
    next unless new_position.x.between?(0, board.length - 1) && new_position.y.between?(0, board.length - 1)

    next if board[new_position.x][new_position.y]

    moves << new_position
  end

  return moves.map { |r| [r, 0] } unless recurse

  results = []
  moves.each do |move|
    submoves = legal_moves_with_scores(board: board, position: move, recurse: false)

    results << [move, submoves.length]
  end

  results.sort_by { |x| x[1] }
end

def tour(board_size:, starting_position:)
  board = Array.new(board_size) { Array.new(board_size) }
  position_history = [starting_position]
  temp_move_number = 0

  while position_history.length < (board_size**2) && (temp_move_number < 3000)
    temp_move_number += 1

    position = position_history.last
    board[position.x][position.y] = position_history.length

    legal_moves_with_scores = legal_moves_with_scores(board: board, position: position, recurse: true)
    puts("temp_move_number:#{temp_move_number} legal_moves_with_scores:#{legal_moves_with_scores}")

    raise "Backtracking not supported yet" if legal_moves_with_scores.empty?

    new_position = legal_moves_with_scores.shift

    puts("chose move: #{new_position}")

    position_history << new_position[0]
  end
end

tour(board_size: 8, starting_position: Point.new(x: 1, y: 2))

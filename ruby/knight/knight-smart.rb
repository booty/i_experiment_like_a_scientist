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

def render_board(board:, position:, new_position:)
  0.upto(board.length - 1) do |y|
    # print("#{y} ")
    0.upto(board[0].length - 1) do |x|
      symbol = board[x][y].to_s
      if x == position.x && y == position.y
        symbol = "*#{symbol}"
      elsif new_position && x == new_position.x && y == new_position.y
        symbol = "Next"
      end
      # print(render_square(contents: symbol, width: 6))
      print("[#{symbol.center(4)}]")
    end
    puts("\n")
  end
end

def render_state(position:, new_position:, legal_moves_with_scores:, move_number:)
  puts("----------------------- Move #{move_number} -----------------------")
  puts("position:#{position} new_position:#{new_position} legal_moves_with_scores:#{legal_moves_with_scores}")
end

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
    results << [
      move,
      legal_moves_with_scores(board: board, position: move, recurse: false).length
    ]
  end

  results.sort_by { |x| x[1] }
end

def tour(board_size:, starting_position:, verbose:)
  board = Array.new(board_size) { Array.new(board_size) }
  position_history = [starting_position]
  move_number = 1

  while position_history.length < (board_size**2)
    move_number += 1

    position = position_history.last
    board[position.x][position.y] = position_history.length

    legal_moves_with_scores = legal_moves_with_scores(board: board, position: position, recurse: true)

    new_position = legal_moves_with_scores.shift[0]

    if verbose
      render_state(position:, new_position:, legal_moves_with_scores:, move_number: move_number)
      render_board(board:, position:, new_position:)
    end

    raise "Backtracking not supported yet" unless new_position

    position_history << new_position

  end

  puts("cool, we won! #{position_history} (#{position_history.length} moves)")
end

# works w/ no backtracking
tour(board_size: 8, starting_position: Point.new(x: 1, y: 2), verbose: true)

# Needs backtracking
# tour(board_size: 8, starting_position: Point.new(x: 1, y: 1))

# frozen_string_literal: true

puts "Hello, from Knight III... ✌️"

Point = Data.define(:x, :y) do
  def +(other)
    Point.new(x + other.x, y + other.y)
  end

  def to_s
    "(#{x},#{y})"
  end

  def inspect
    to_s
  end

  def inbounds?(size)
    x.between?(0, size - 1) && y.between?(0, size - 1)
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
    0.upto(board[0].length - 1) do |x|
      symbol = board[x][y].to_s
      if x == position.x && y == position.y
        symbol = "*#{symbol}"
      elsif new_position && x == new_position.x && y == new_position.y
        symbol = "Next"
      end
      print("[#{symbol.center(4)}]")
    end
    puts("\n")
  end
end

def render_state(position:, new_position:, scored_moves:, move_number:)
  puts("----------------------- Move #{move_number} -----------------------")
  puts("position:#{position} new_position:#{new_position} legal_moves_with_scores:#{legal_moves_with_scores}")
end

# The heuristic here is: choose the move with the lowest number of possible resulting moves
def scored_moves(board:, position:, recurse:)
  moves = DELTAS.filter_map do |delta|
    new_position = position + delta

    next unless new_position.inbounds?(board.length)
    next if board[new_position.x][new_position.y] # knight has already visited

    new_position
  end

  return moves.map { |r| [r, 0] } unless recurse

  moves.map do |move|
    [
      move,
      scored_moves(board: board, position: move, recurse: false).length
    ]
  end.sort_by { |x| x[1] }
end

def tour(board_size:, starting_position:, verbose:)
  board = Array.new(board_size) { Array.new(board_size) }
  position_history = [starting_position]
  move_number = 1

  while position_history.length < (board_size**2)
    move_number += 1

    position = position_history.last
    board[position.x][position.y] = position_history.length

    scored_moves = scored_moves(board:, position:, recurse: true)
    new_position = scored_moves.shift&.first

    if verbose
      render_state(position:, new_position:, scored_moves:, move_number: move_number)
      render_board(board:, position:, new_position:)
    end

    raise "Backtracking not supported yet" unless new_position

    position_history << new_position
  end

  puts("Cool, we won! #{position_history.join(' → ')} (#{position_history.length} moves)")
end

tour(board_size: 10, starting_position: Point.new(x: 1, y: 2), verbose: false)

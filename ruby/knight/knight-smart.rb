# frozen_string_literal: true

require "benchmark/ips"

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
      if x == position&.x && y == position&.y
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
  puts("position:#{position} new_position:#{new_position} scored_moves:#{scored_moves}")
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
  scored_moves_history = []
  backtracking = false

  while position_history.length < (board_size**2)
    move_number += 1

    # OLD
    # position = position_history.last
    # board[position.x][position.y] = position_history.length
    # scored_moves = scored_moves(board:, position:, recurse: true)
    # new_position = scored_moves.shift&.first

    # Mark the board
    if backtracking
      puts "Backtracking..."
      scored_moves = scored_moves_history.pop
    else
      board[position_history.last.x][position_history.last.y] = position_history.length
      scored_moves = scored_moves(board:, position: position_history.last, recurse: true)
      scored_moves_history.push(scored_moves)
    end

    new_position = scored_moves.shift&.first

    if verbose
      render_state(position: position_history.last, new_position:, scored_moves:, move_number: move_number)
      render_board(board:, position: position_history.last, new_position:)
    end

    if new_position
      backtracking = false
    else
      backtracking = true
      # raise "Backtracking not supported yet (board_size:#{board_size}, starting position: #{starting_position})"
    end

    position_history << new_position unless backtracking
  end

  puts("Cool, we won! #{position_history.join(' → ')} (#{position_history.length} moves)") if verbose
end

# Will cause a backtrack
tour(board_size: 11, starting_position: Point.new(1, 9), verbose: true)

# Benchmark.ips do |bm|
#   bm.config(warmup: 2, time: 5)

#   8.upto(15) do |board_size|
#     edge = board_size - 1
#     starting_positions = [
#       Point.new(x: 0, y: 0),
#       Point.new(x: 0, y: edge),
#       Point.new(x: edge, y: 0),
#       Point.new(x: edge, y: edge),
#       Point.new(x: 1, y: 1),
#       Point.new(x: 1, y: edge - 1),
#       Point.new(x: edge - 1, y: 1),
#       Point.new(x: edge - 1, y: edge - 1),
#       Point.new(x: edge / 2, y: edge / 2)
#     ]
#     bm.report("Board size: #{board_size} (#{starting_positions.length} starting positions)") do
#       # puts("Will benchmark board size #{board_size}")

#       starting_positions.each do |sp|
#         tour(board_size: board_size, starting_position: sp, verbose: false)
#       end
#     end
#   end

#   bm.compare!
# end

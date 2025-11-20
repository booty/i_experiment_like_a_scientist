# frozen_string_literal: true

require "benchmark/ips"

puts "Hello, from Knight III... ✌️"

Point = Data.define(:x, :y) do
  def +(other) = Point.new(x + other.x, y + other.y)

  def to_s = "(#{x},#{y})"

  def inspect = to_s

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

def render_board(board:, position:)
  edge = board.length - 1
  0.upto(edge) do |y|
    0.upto(edge) do |x|
      symbol = if position && x == position.x && y == position.y
                 "*#{board[x][y]}"
               else
                 board[x][y].to_s
               end
      print("[#{symbol.center(4)}]")
    end
    puts("\n")
  end
end

def render_header(move_number:, starting_position:, backtracking:)
  puts("----------------------- Move #{move_number} (start was #{starting_position}) -----------------------")
  puts("Currently backtracking") if backtracking
end

def render_state(position:, scored_moves:, position_history:)
  puts("position:#{position} scored_moves:#{scored_moves}")
  puts("position_history:#{position_history.join(' → ')}")
end

def neighbors_for(size:, position:, neighbors_cache:)
  neighbors_cache[position] ||= DELTAS.filter_map do |d|
    p2 = position + d
    p2 if p2.inbounds?(size)
  end
end

def moves_from(board:, position:, neighbors_cache:)
  neighbors_for(size: board.length, position:, neighbors_cache:).reject { |p2| board[p2.x][p2.y] }
end

# The heuristic here is: choose the move with the lowest number of possible
# resulting moves (Warnsdorff’s...ish)
def scored_moves(board:, position:, recurse:, neighbors_cache:)
  moves = moves_from(board:, position:, neighbors_cache:)
  return moves.map { [_1, 0] } unless recurse

  moves.map { |m| [m, moves_from(board:, position: m, neighbors_cache:).size] }.sort_by(&:last)
end

def tour(board_size:, starting_position:, verbose:)
  neighbors_cache = {}
  board = Array.new(board_size) { Array.new(board_size) }
  position_history = [starting_position]
  move_number = 0
  scored_moves_history = []
  backtracking = false

  while position_history.length <= (board_size**2)
    move_number += 1

    render_header(move_number:, backtracking:, starting_position:) if verbose

    if backtracking
      scored_moves = scored_moves_history.pop
    else
      scored_moves = scored_moves(board:, position: position_history.last, recurse: true, neighbors_cache:)
      scored_moves_history.push(scored_moves)
    end

    new_position = scored_moves.shift&.first

    if new_position
      backtracking = false
      position_history << new_position
      board[new_position.x][new_position.y] = position_history.length
    else
      backtracking = true
      if scored_moves_history.empty?
        raise "This combination (board_size #{board_size}; starting position #{starting_position}) has no solution."
      end
    end
    next unless verbose

    render_state(position: position_history.last, scored_moves:,
                 position_history:)
    render_board(board:, position: position_history.last)
  end

  puts("Cool, we won! #{position_history.join(' → ')} (#{position_history.length} moves)") if verbose
end

tour(board_size: 6, starting_position: Point.new(4, 4), verbose: true)

Benchmark.ips do |bm|
  bm.config(warmup: 0.5, time: 3)

  4.upto(15) do |board_size|
    bm.report("Board size: #{board_size}") do
      start = Point.new(rand(0..board_size - 1), rand(0..board_size - 1))
      tour(board_size: board_size, starting_position: start, verbose: false)
    end
  end
end

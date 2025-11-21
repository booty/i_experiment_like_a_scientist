# frozen_string_literal: true

require "benchmark/ips"

puts "Hello, from Knight IV... ✌️ (packed int edition)"

# Positions are represented as a single Integer in [0, size*size).
# Encoding/decoding helpers:

def pack_pos(x, y, size)
  x * size + y
end

def unpack_pos(pos, size)
  [pos / size, pos % size]
end

def inbounds?(x, y, size)
  x.between?(0, size - 1) && y.between?(0, size - 1)
end

def pos_to_s(pos, size)
  x, y = unpack_pos(pos, size)
  "(#{x},#{y})"
end

# Knight move deltas as (dx, dy) pairs
DELTAS = [
  [2, 1],
  [2, -1],
  [-2, 1],
  [-2, -1],
  [1, 2],
  [1, -2],
  [-1, 2],
  [-1, -2]
].freeze

def render_board(board:, board_size:, position:)
  edge = board_size - 1
  pos_x, pos_y = position ? unpack_pos(position, board_size) : [nil, nil]

  0.upto(edge) do |y|
    0.upto(edge) do |x|
      idx = pack_pos(x, y, board_size)
      value = board[idx]

      symbol = if position && x == pos_x && y == pos_y
                 "*#{value}"
               else
                 value.to_s
               end

      print("[#{symbol.center(4)}]")
    end
    puts("\n")
  end
end

def render_header(move_number:, starting_position:, backtracking:, board_size:)
  puts("----------------------- Move #{move_number} (start was #{pos_to_s(starting_position,
                                                                          board_size)}) -----------------------")
  puts("Currently backtracking") if backtracking
end

def render_state(position:, scored_moves:, position_history:)
  puts("position:#{position} scored_moves:#{scored_moves}")
  puts("position_history:#{position_history.join(' → ')}")
end

# Precompute legal neighbors (in packed-int form) per position
# Cache is a Hash[pos_int] => [neighbor_pos_int, ...]

def neighbors_for(size:, position:, neighbors_cache:)
  neighbors_cache[position] ||= begin
    x, y = unpack_pos(position, size)

    DELTAS.filter_map do |dx, dy|
      nx = x + dx
      ny = y + dy
      next unless inbounds?(nx, ny, size)

      pack_pos(nx, ny, size)
    end
  end
end

def moves_from(board:, board_size:, position:, neighbors_cache:)
  neighbors_for(size: board_size, position:, neighbors_cache:).reject { |p2| board[p2] }
end

# The heuristic here is: choose the move with the lowest number of possible
# resulting moves (Warnsdorff’s...ish)

def scored_moves(board:, board_size:, position:, recurse:, neighbors_cache:)
  moves = moves_from(board:, board_size:, position:, neighbors_cache:)
  return moves.map { [_1, 0] } unless recurse

  moves
    .map { |m| [m, moves_from(board:, board_size:, position: m, neighbors_cache:).size] }
    .sort_by!(&:last)
end

def tour(board_size:, starting_position:, verbose:)
  neighbors_cache = {}
  # 1D board, indexed by packed position
  board = Array.new(board_size * board_size)
  position_history = [starting_position]
  move_number = 0
  scored_moves_history = []
  backtracking = false

  # Mark starting position as the first move
  board[starting_position] = 1

  # We already visited the starting square, so we need (size^2 - 1) more moves
  while position_history.length < board_size * board_size
    move_number += 1

    render_header(move_number:, backtracking:, starting_position:, board_size:) if verbose

    if backtracking
      scored_moves = scored_moves_history.pop
    else
      scored_moves = scored_moves(board:, board_size:, position: position_history.last, recurse: true, neighbors_cache:)
      scored_moves_history.push(scored_moves)
    end

    new_position = scored_moves.shift&.first

    if new_position
      backtracking = false
      position_history << new_position
      board[new_position] = position_history.length
    else
      backtracking = true
      if scored_moves_history.empty?
        raise "This combination (board_size #{board_size}; starting position #{pos_to_s(starting_position,
                                                                                        board_size)}) has no solution."
      end
    end

    next unless verbose

    render_state(position: position_history.last, scored_moves:, position_history:)
    render_board(board:, board_size:, position: position_history.last)
  end

  puts("Cool, we won! #{position_history.join(' → ')} (#{position_history.length} moves)") if verbose
end

# Demo run
start_demo = pack_pos(4, 4, 6)
tour(board_size: 6, starting_position: start_demo, verbose: true)

# Benchmarks
Benchmark.ips do |bm|
  bm.config(warmup: 0.5, time: 3)

  5.upto(15) do |board_size|
    bm.report("Board size: #{board_size}") do
      sx = rand(0...board_size)
      sy = rand(0...board_size)
      start = pack_pos(sx, sy, board_size)
      tour(board_size:, starting_position: start, verbose: false)
    end
  end
end

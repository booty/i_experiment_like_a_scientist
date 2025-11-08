# frozen_string_literal: true

puts "Hello, from Knight II... ✌️"

class Tour
  attr_accessor :board

  Point = Data.define(:x, :y)

  MOVES = {
    0 => Point.new(x: 2, y: 1),
    1 => Point.new(x: 2, y: -1),
    2 => Point.new(x: -2, y: 1),
    3 => Point.new(x: -2, y: -1),
    4 => Point.new(x: 1, y: 2),
    5 => Point.new(x: 1, y: -2),
    6 => Point.new(x: -1, y: 2),
    7 => Point.new(x: -1, y: -2)
  }.freeze

  def initialize(board_size:, initial_x:, initial_y:)
    @board = Array.new(board_size) { Array.new(board_size) }
    @position_history = [Point.new(x: initial_x, y: initial_y)]
  end

  def play!
    until win?
      # raise "Whoa, shutting down" if move_number > 3

      # Get possible moves
      pp = possible_positions()
      chosen_next_position = pp.sample
      render_state(possible_positions: pp, chosen_next_position:)

      # If there are no possible moves, backtrack
      raise "Backtracking not implemented yet" unless chosen_next_position

      # If there is a possible move, make that move
      @board[current_position.x][current_position.y] = move_number()

      @position_history.push(chosen_next_position)
    end
  end

  private

  def possible_positions
    result = []

    0.upto(7) do |move_number|
      move = MOVES[move_number]
      new_position = Point.new(x: current_position.x + move.x, y: current_position.y + move.y)
      next unless move_in_bounds?(new_position:)
      next unless move_valid?(new_position:)

      result << new_position
    end

    result
  end

  def current_position
    @position_history.last
  end

  def move_number
    @position_history.length
  end

  def win?
    @position_history.length == (board_size**2)
  end

  def board_size
    @board.length
  end

  def move_in_bounds?(new_position:)
    return false if new_position.x.negative? || new_position.y.negative?
    return false if new_position.x >= board_size || new_position.y >= board_size

    true
  end

  def move_valid?(new_position:)
    !@board[new_position.x][new_position.y]
  end

  def render_square(contents:, width:)
    "[#{contents.center(width)}]"
  end

  def render_board(chosen_next_position:)
    0.upto(board_size - 1) do |y|
      print("#{y} ")
      0.upto(board_size - 1) do |x|
        symbol = if x == current_position.x && y == current_position.y
                   "Curr"
                 elsif chosen_next_position && x == chosen_next_position.x && y == chosen_next_position.y
                   "Next"
                 else
                   @board[x][y].to_s
                 end
        print(render_square(contents: symbol, width: 6))
      end
      puts("\n")
    end
  end

  def render_state(possible_positions:, chosen_next_position:)
    puts("position_history: #{@position_history}")
    puts("possible_positions: #{possible_positions}")
    puts("chosen_next_position: #{chosen_next_position}")
    render_board(chosen_next_position:)
  end
end

Tour.new(board_size: 8, initial_x: 1, initial_y: 2).play!

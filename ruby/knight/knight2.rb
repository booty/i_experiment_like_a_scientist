# frozen_string_literal: true

VERBOSE = true

puts "Hello, from Knight II... ✌️"

class Tour
  attr_accessor :board

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
    @possible_next_positions_history = []
  end

  def play!
    backtracking = false
    move_count = 0
    backtrack_count = 0

    puts("\n\n\n\n\n\n\n")

    until win?
      move_count += 1

      # raise "Fuck" if move_count > 100

      puts("\n          -----[ Turn #{move_count} ]-----") if VERBOSE
      puts("backtracking:#{backtracking} move_count:#{move_count} backtrack_count:#{backtrack_count}") if VERBOSE

      # Get a list of possible moves
      @board[current_position.x][current_position.y] = move_number()
      possible_next_positions = if backtracking
                                  @possible_next_positions_history.pop
                                else
                                  possible_next_positions()
                                end
      puts("possible_next_positions: #{possible_next_positions}") if VERBOSE
      next_position = possible_next_positions.pop

      # render_board(chosen_next_position: next_position)

      # If there are no moves, we should backtrack
      unless next_position
        # raise "I refuse to backtrack."
        puts("Will backtrack next turn") if VERBOSE
        backtracking = true
        backtrack_count += 1
        @board[current_position.x][current_position.y] = nil
        @position_history.pop
        next
      end

      # Choose one of the possible moves
      backtracking = false
      @position_history.push(next_position)
      puts("next_position: #{next_position} @position_history: #{@position_history}") if VERBOSE
      @possible_next_positions_history.push(possible_next_positions)

    end

    puts "Looks like we won."
  end

  private

  def possible_next_positions
    puts "Generating new positions"
    result = []

    0.upto(7) do |move_number|
      move = MOVES[move_number]
      new_position = Point.new(x: current_position.x + move.x, y: current_position.y + move.y) # TODO: use overloaded Point#+ operator
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
    result = @board[new_position.x][new_position.y]
    puts("move_valid?(#{new_position}): #{result}")
    !result
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

  def render_state(next_:, chosen_next_position:)
    puts("position_history: #{@position_history}")
    puts("next_: #{next_}")
    puts("chosen_next_position: #{chosen_next_position}")
    render_board(chosen_next_position:)
  end
end

Tour.new(board_size: 8, initial_x: 1, initial_y: 2).play!

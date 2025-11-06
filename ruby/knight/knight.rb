# frozen_string_literal: true

Point = Data.define(:x, :y)

BOARD_SIZE = 8
EMPTY_BOARD = -> { Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) } }
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

class Knight
  attr_accessor :board, :position

  def possible_moves
    result = []

    0.upto(7) do |move_number|
      next unless move_in_bounds?(move_number:, board:, position:)

      result << move_number
    end

    result
  end

  def render_square(contents:, width:)
    "[#{contents.center(width)}]"
  end

  def render_board
    # puts(@board)
    0.upto(BOARD_SIZE - 1) do |y|
      print("#{y} ")
      0.upto(BOARD_SIZE - 1) do |x|
        symbol = if x == @position.x && y == @position.y
                   "⭐️"
                 else
                   @board[@position.x][@position.y].to_s
                 end
        print(render_square(contents: symbol, width: 6))
      end
      puts("\n")
    end
  end

  def initialize(board:, position:)
    @board = board
    @position = position
  end

  private

  def move_in_bounds?(move_number:, board:, position:)
    move = MOVES[move_number]
    new_position = Point.new(x: @position.x + move.x, y: @position.y + move.y)

    # puts("move #{move_number} (#{move}): new coords would be #{new_position}")
    return false if new_position.x.negative?
    return false if new_position.y.negative?
    return false if new_position.x >= BOARD_SIZE
    return false if new_position.y >= BOARD_SIZE

    true
  end
end

puts("Hello, Guard?")

foo = Knight.new(board: EMPTY_BOARD.call, position: Point.new(1, 2))

puts("Possible moves: #{foo.possible_moves}")
puts(foo.render_board)

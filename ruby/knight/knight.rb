# frozen_string_literal: true

BOARD_SIZE = 8
EMPTY_BOARD = -> { Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) } }

MOVES = {
  0 => { x: 2, y: 1 },
  1 => { x: 2, y: -1 },
  2 => { x: -2, y: 1 },
  3 => { x: -2, y: -1 },
  4 => { x: 1, y: 2 },
  5 => { x: 1, y: -2 },
  6 => { x: -1, y: 2 },
  7 => { x: -1, y: -2 }
}.freeze

class Knight
  attr_accessor :board, :curr_xpos, :curr_ypos

  def possible_moves
    result = []

    0.upto(7) do |move_num|
      move = MOVES[move_num]

      newx = @curr_xpos + move[:x]
      newy = @curr_ypos + move[:y]

      puts("move #{move_num} (#{move}): new coords would be #{newx},#{newy}")
      next if newx.negative?
      next if newy.negative?
      next if newx >= BOARD_SIZE
      next if newy >= BOARD_SIZE

      result << move_num
    end

    result
  end

  def render_square(contents:, width:)
    "[#{contents.center(width)}]"
  end

  def render_board
    0.upto(BOARD_SIZE - 1) do |y|
      print("#{y} ")
      0.upto(BOARD_SIZE - 1) do |x|
        symbol = if x == @curr_xpos && y == @curr_ypos
                   "⭐️"
                 else
                   ""
                 end
        print(render_square(contents: symbol, width: 6))
      end
      puts("\n")
    end
  end

  def initialize(board:, curr_xpos:, curr_ypos:)
    @board = board
    @curr_xpos = curr_xpos
    @curr_ypos = curr_ypos
  end
end

puts("Hello, Guard?")

foo = Knight.new(board: EMPTY_BOARD, curr_xpos: 1, curr_ypos: 2)

puts(foo.possible_moves)
puts(foo.render_board)

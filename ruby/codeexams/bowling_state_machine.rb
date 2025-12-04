# frozen_string_literal: true

# Kata: Bowling State Machine
#
# Model a single player's bowling game as a state machine
#
# Public Usage/API:
#
#   game = BowlingGame.new()
#   game.roll(3)          # 3 is the number of pins knocked down
#   game.roll([3,4,5])    # alternatively, multiple rolls as an array
#   game.state            # Returns the frame number, score, and the number of pins remaining
#

class BowlingGame
  def initialize
    @current_frame = []
    @frame_history = []
  end

  def roll(pins)
    Array(pins).each do |p|
      single_roll(p)
    end
  end

  def state
    {
      "Frame history": @frame_history,
      "Current frame": @current_frame,
      "Current frame number": frame_number,
      "Frame scores": scores,
      Score: scores.sum,
      "Game over": game_over?
    }
  end

  def scores
    result = []
    @frame_history.each_with_index do |frame, idx|
      next_rolls = (@frame_history[(idx + 1)..] + @current_frame).flatten
      # puts "idx:#{idx} next_rolls:#{next_rolls}"
      result << if frame == [10] # strike
                  (10 + next_rolls[0].to_i + next_rolls[1].to_i)
                elsif frame.sum == 10 # spare
                  (10 + next_rolls[0].to_i)
                else # open frame
                  frame.sum
                end
    end
    result
  end

  private

  def game_over?
    @frame_history.length == 10
  end

  def single_roll(pins)
    raise ArgumentError, "Game is over" if game_over?
    raise ArgumentError, "You can't knock down #{pins} at once" if pins > 10

    frame_number == 10 ? single_roll_10th_frame(pins) : single_roll_normal_frame(pins)
  end

  def single_roll_normal_frame(pins)
    pins_standing = 10 - @current_frame.sum
    raise ArgumentError, "Can't knock down #{pins} pins if only #{pins_standing} remain" if pins > pins_standing

    @current_frame << pins

    return unless @current_frame.sum == 10 || @current_frame.length == 2

    @frame_history << @current_frame.dup
    @current_frame = []
  end

  def single_roll_10th_frame(pins)
    # TODO: sanity checking, how many pins are standing?
    rolls_allowed = @current_frame.sum >= 10 ? 3 : 2

    @current_frame << pins

    return unless @current_frame.length == rolls_allowed

    @frame_history << @current_frame.dup
    @current_frame = []
  end

  def frame_number
    @frame_history.length + 1
  end
end

game = BowlingGame.new

nine_frames = [1, 2, 3, 4, 5, 6, 7, 8, 9]
nine_perfect_frames = Array.new(9) { 10 }
# game.roll([10, 10, 10, 10, 10, 10, 10, 10, 10, 10])
game.roll(nine_perfect_frames + [1, 2])
puts game.state

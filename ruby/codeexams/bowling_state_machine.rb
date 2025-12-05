# frozen_string_literal: true

require "minitest/autorun"

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
  class RollingWhenGameOver < ArgumentError; end
  class InvalidPinCount < ArgumentError; end
  class InvalidRoll < ArgumentError; end

  def initialize
    @current_frame = []
    @frame_history = []
  end

  def roll(pins)
    pins_sanitized = Array(pins).select { |x| x.is_a?(Integer) && x.between?(0, 10) }
    if pins_sanitized != Array(pins)
      raise InvalidRoll,
            "All rolls must be integers, or arrays of integers, between 0 and 10"
    end

    Array(pins_sanitized).each do |p|
      single_roll(p)
    end
  end

  def scores
    result = [@current_frame.sum]
    @frame_history.each_with_index do |frame, idx|
      next_rolls = (@frame_history[(idx + 1)..] + @current_frame).flatten
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

  def score
    scores.sum
  end

  def game_over?
    @frame_history.length == 10
  end

  private

  def close_frame
    @frame_history << @current_frame.dup
    @current_frame = []
  end

  def debug
    {
      frame_history: @frame_history,
      current_frame: @current_frame,
      frame_number: frame_number,
      scores: scores,
      score: score,
      game_over?: game_over?
    }
  end

  def single_roll(pins)
    raise RollingWhenGameOver, "Game is over" if game_over?

    frame_number == 10 ? single_roll_10th_frame(pins) : single_roll_normal_frame(pins)
  end

  def single_roll_normal_frame(pins)
    pins_standing = 10 - @current_frame.sum
    raise InvalidPinCount, "Can't knock down #{pins} pins if only #{pins_standing} remain" if pins > pins_standing

    @current_frame << pins

    return unless @current_frame.sum == 10 || @current_frame.length == 2

    close_frame
  end

  def single_roll_10th_frame(pins)
    pins_down = @current_frame.sum
    pins_standing = if (pins_down % 10).zero?
                      10
                    else
                      10 - (pins_down % 10)
                    end

    if pins > pins_standing
      raise InvalidPinCount, "Can't knock down #{pins} pins if only #{pins_standing} remain"
    end

    @current_frame << pins
    rolls_allowed = @current_frame.sum >= 10 ? 3 : 2

    return unless @current_frame.length == rolls_allowed

    close_frame()
  end

  def frame_number
    @frame_history.length + 1
  end
end

class TestBowlingGame < Minitest::Test
  NINE_PERFECT_FRAMES = Array.new(9) { 10 }
  NINE_LOUSY_FRAMES = Array.new(18) { 1 }
  PERFECT_GAME = Array.new(12) { 10 }

  def test_invalid_rolls
    g = BowlingGame.new
    assert_raises(BowlingGame::InvalidRoll) { g.roll(nil) }
    assert_raises(BowlingGame::InvalidRoll) { g.roll("foo") }
    assert_raises(BowlingGame::InvalidRoll) { g.roll(5.5) }
    assert_raises(BowlingGame::InvalidRoll) { g.roll(-1) }
    assert_raises(BowlingGame::InvalidRoll) { g.roll(11) }
    assert_raises(BowlingGame::InvalidRoll) { g.roll([1, 999]) }
    assert_raises(BowlingGame::InvalidRoll) { g.roll([1, "foo"]) }
  end

  def test_rolling_when_game_over_raises_open_10th
    game = BowlingGame.new
    assert_raises(BowlingGame::RollingWhenGameOver) do
      game.roll(NINE_LOUSY_FRAMES + [1, 1, 1])
    end
  end

  def test_rolling_when_game_over_raises_strike_10th
    game = BowlingGame.new
    game.roll(NINE_PERFECT_FRAMES + [10, 1, 1])
    assert_raises(BowlingGame::RollingWhenGameOver) do
      game.roll(1)
    end
  end

  def test_game_over_spare_10th
    game = BowlingGame.new
    game.roll(NINE_PERFECT_FRAMES)
    game.roll(9)
    game.roll(1)
    game.roll(1)
    assert_raises(BowlingGame::RollingWhenGameOver) do
      game.roll(1)
    end
  end

  def test_scoring
    g = BowlingGame.new
    assert_equal(0, g.score)

    g.roll(1)
    assert_equal(1, g.score)

    g.roll(2)
    assert_equal(3, g.score)

    g.roll(10)
    assert_equal(13, g.score)

    g.roll([3, 4])
    assert_equal(27, g.score)

    g.roll([10, 10, 10])
    assert_equal(87, g.score)

    g.roll([9, 1])
    assert_equal(116, g.score)

    g.roll([2, 2, 2, 2, 2, 2])
    assert_equal(130, g.score)
    assert_equal(true, g.game_over?)
  end

  def test_perfect_game
    g = BowlingGame.new
    g.roll(PERFECT_GAME)
    assert_equal(true, g.game_over?)
    assert_equal(300, g.score)
  end

  def test_invalid_pin_counts
    g = BowlingGame.new

    g.roll(1)
    assert_raises(BowlingGame::InvalidPinCount) do
      g.roll(10)
    end
    g.roll(1)

    g2 = BowlingGame.new
    g2.roll(NINE_PERFECT_FRAMES)
    g2.roll(1)
    assert_raises(BowlingGame::InvalidPinCount) do
      g2.roll(10)
    end

    g3 = BowlingGame.new
    g3.roll(NINE_PERFECT_FRAMES)
    g3.roll([10, 1])
    assert_raises(BowlingGame::InvalidPinCount) do
      g3.roll(10)
    end
  end
end

# frozen_string_literal: true

require "minitest/autorun"
require_relative "elevator"

class ElevatorTest < Minitest::Test
  def test_initial_state
    elevator = Elevator.new(floor_count: 5)

    assert_equal 5, elevator.instance_variable_get(:@floor_count)
    assert_equal [false, false, false, false, false],
                 elevator.instance_variable_get(:@buttons)
    assert_equal :idle, elevator.instance_variable_get(:@current_direction)
    assert_equal 0, elevator.instance_variable_get(:@current_floor)
    assert_equal 0, elevator.instance_variable_get(:@time)
  end

  def test_simple_upward_movement_to_single_floor
    elevator = Elevator.new(floor_count: 5)

    elevator.hit_button(floor_number: 3)
    elevator.pass_time(time_units: 3)

    current_floor = elevator.instance_variable_get(:@current_floor)
    buttons       = elevator.instance_variable_get(:@buttons)

    assert_equal 3, current_floor
    # button for floor 3 should have been cleared after arrival
    assert_equal [false, false, false, false, false], buttons
  end

  def test_returns_to_ground_when_no_buttons
    elevator = Elevator.new(floor_count: 5)

    elevator.hit_button(floor_number: 3)
    elevator.pass_time(time_units: 3) # go 0 -> 3

    # Now no buttons are lit; elevator should start drifting down
    elevator.pass_time(time_units: 3) # 3 -> 0

    current_floor = elevator.instance_variable_get(:@current_floor)
    assert_equal 0, current_floor

    direction = elevator.instance_variable_get(:@current_direction)
    assert_equal :idle, direction
  end

  def test_serves_multiple_floors_on_the_way_up_and_down
    elevator = Elevator.new(floor_count: 5)

    elevator.hit_button(floor_number: 4)
    elevator.hit_button(floor_number: 2)
    elevator.hit_button(floor_number: 3)

    floors = []
    8.times do
      elevator.pass_time(time_units: 1)
      floors << elevator.instance_variable_get(:@current_floor)
    end

    # Expected path:
    # 0 -> 1 -> 2 (serve 2) -> 3 (serve 3) -> 4 (serve 4) -> 3 -> 2 -> 1 -> 0
    # We record floors after each tick, so: [1,2,3,4,3,2,1,0]
    assert_equal [1, 2, 3, 4, 3, 2, 1, 0], floors

    buttons = elevator.instance_variable_get(:@buttons)
    assert_equal [false, false, false, false, false], buttons
  end

  def test_hit_button_ignores_current_floor
    elevator = Elevator.new(floor_count: 5)

    # current floor is 0; hitting button for floor 0 should be ignored
    elevator.hit_button(floor_number: 0)

    buttons = elevator.instance_variable_get(:@buttons)
    assert_equal [false, false, false, false, false], buttons
  end

  def test_hit_button_out_of_range_raises
    elevator = Elevator.new(floor_count: 5)

    assert_raises(ArgumentError) { elevator.hit_button(floor_number: -1) }
    assert_raises(ArgumentError) { elevator.hit_button(floor_number: 5) }
  end

  def test_time_increments_with_pass_time
    elevator = Elevator.new(floor_count: 5)

    elevator.pass_time(time_units: 3)
    time = elevator.instance_variable_get(:@time)
    assert_equal 3, time

    elevator.pass_time(time_units: 2)
    time = elevator.instance_variable_get(:@time)
    assert_equal 5, time
  end

  def test_direction_stays_in_current_direction_when_buttons_above_and_below
    elevator = Elevator.new(floor_count: 7)

    # Request floors above and below after moving up once
    elevator.hit_button(floor_number: 3)
    elevator.hit_button(floor_number: 1)

    elevator.pass_time(time_units: 1) # move 0 -> 1 (serve 1)
    # Now only floor 3 is above; request a floor below
    elevator.hit_button(floor_number: 0)

    # At floor 1, with buttons at 0 (below) and 3 (above)
    # Current direction should remain :up while both exist
    elevator.pass_time(time_units: 1)
    direction = elevator.instance_variable_get(:@current_direction)
    assert_equal :up, direction
  end
end

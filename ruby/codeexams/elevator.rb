# frozen_string_literal: true

class Elevator
  def initialize(floor_count:)
    raise ArgumentError, "I don't think you need an elevator!" unless floor_count.positive?

    @floor_count = floor_count
    @buttons = Array.new(floor_count, false)
    @current_direction = :idle
    @current_floor = 0
    @time = 0
  end

  def hit_button(floor_number:)
    raise ArgumentError if floor_number < 0 || floor_number >= @floor_count
    return if floor_number == @current_floor

    @buttons[floor_number] = true
  end

  # 1 time unit = the time it takes for an elevator to traverse 1 floor
  def pass_time(time_units: 1, render: false)
    time_units.times do
      @time += 1
      buttons_above = @buttons[@current_floor + 1..].to_a.any?
      buttons_below = @buttons[0..[0, @current_floor - 1].max].any?

      puts("time:#{@time} buttons_above:#{buttons_above} buttons_below:#{buttons_below}") if render
      @current_direction = if buttons_above && buttons_below && %i[up down].include?(@current_direction)
                             @current_direction
                           elsif buttons_above && !buttons_below
                             :up
                           elsif buttons_below && !buttons_above
                             :down
                           elsif !buttons_above && !buttons_below && @current_floor == 0
                             :idle
                           else
                             :down # if no buttons pressed, return to ground floor
                           end

      if @current_direction == :up
        @current_floor += 1
      elsif @current_direction == :down
        @current_floor -= 1
      end

      # More cosmetic than necessary
      @current_direction = :idle if [0, @floor_count - 1].include?(@current_floor)

      @buttons[@current_floor] = false
      render() if render
    end
  end

  def render
    elevator = if @current_direction == :up
                 " ⬆️"
               elsif @current_direction == :down
                 " ⬇️"
               else
                 " 😴"
               end

    @buttons.reverse.each_with_index do |x, idx|
      floor_label = @floor_count - idx - 1
      print("[#{floor_label}:#{x ? '🔆' : '  '}]")
      print(elevator) if floor_label == @current_floor
      puts("")
    end
    puts("\n\n")
  end
end

# elevator = Elevator.new(floor_count: 5)
# elevator.hit_button(floor_number: 4)
# elevator.hit_button(floor_number: 2)
# elevator.hit_button(floor_number: 3)
# elevator.pass_time(time_units: 10, render: true)

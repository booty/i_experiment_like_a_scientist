# frozen_string_literal: true

require "irb"

class Array
  def my_flatten
    result = []

    each do |x|
      if x.is_a?(Array)
        result += x.my_flatten
      else
        result.push(x)
      end
    end
    result
  end
end

puts([[1, 2, 3], 4, [5, 6, 7, [8, 9, 10, [11, 12, 13]]]].my_flatten.inspect)

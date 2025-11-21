# frozen_string_literal: true

class String
  def rle
    return "" if self == ""

    result = ""
    last_char = ""
    counter = 1
    each_char do |c|
      if c == last_char
        counter += 1
      else
        result << counter.to_s if last_char != "" && counter > 1
        result << last_char
        counter = 1
      end

      last_char = c
    end
    result << counter.to_s if counter > 1
    result << last_char
    result
  end

  def rle2
    return "" if self == ""

    result = ""
    counter = 1

    0.upto(length - 1) do |i|
      if i.positive? && self[i] == self[i - 1]
        counter += 1
      else
        result << counter.to_s if counter > 1
        result << self[i]
      end
    end

    result
  end
end

message = "Hello Woooooooorld!"
puts(message.rle2)

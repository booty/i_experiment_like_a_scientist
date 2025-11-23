# frozen_string_literal: true

class String
  def rle_encode
    return "" if self == ""

    result = []
    counter = 1
    0.upto(length - 1) do |i|
      next unless i.positive?

      puts "  i:#{i} self[i]:#{self[i]}"

      new_char = (self[i] != self[i - 1])

      if new_char
        result << counter
        result << self[i - 1]
        counter = 1
      else
        counter += 1
      end
    end
    result << counter
    result << self[-1]

    result.join
  end

  def rle_decode
    result = []

    tokens = scan(/[A-Za-z]+|\d+/)
    puts("tokens: #{tokens}")
    tokens.each_with_index do |token, index|
      if token.match?(/\d+/)
        # puts("#{}")
        result << tokens[index + 1].to_s * token.to_i
      end
    end
    result.join
  end
end

test_strings = ["AAABBBCCC", "", "BROOM", "Zzzz"]

test_strings.each do |s|
  puts "--- #{s} ---"
  puts "original: #{s}"
  encoded = s.rle_encode
  puts "encoded: #{encoded}"
  result = encoded.rle_decode
  puts "encoded+decoded: #{result}"
  puts(s == result)
  puts ""
end

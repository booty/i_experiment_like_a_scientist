# frozen_string_literal: true

CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
string_grower = Enumerator.new do |y|
  str = ""
  loop do
    str += CHARS[rand(0..(CHARS.length - 1))]
    y << str
  end
end

puts string_grower.take(5)

fib = Enumerator.new do |y|
  prev = 1
  curr = 1
  loop do
    y << prev
    prev, curr = curr, curr + prev
  end
end

puts fib.take(10)

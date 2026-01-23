# frozen_string_literal: true

# Look at 2 through n-1
def prime?(n)
  return false unless n.is_a?(Integer)
  return false if n < 2
  return false if (n % 2).zero?

  limit = Math.sqrt(n).to_i

  i = 3
  while i < limit
    return false if (n % i).zero?

    i += 2
  end
  true
end

test_cases = [
  [-1, false],
  [0, false],
  [3.3, false],
  ["cat", false],
  [4, false],
  [7, true],
  [71, true],
  [1447, true],
  [7919, true],
  [111_121_891, true],
  [111_121_892, false],
  [11_111_125_199, true]
]

test_cases.each do |test|
  actual = prime?(test[0])
  expected = test[1]
  pass = actual == expected ? "✅" : "❌"
  puts "input:#{test[0]} expected:#{expected} actual:#{actual} #{pass}"
end

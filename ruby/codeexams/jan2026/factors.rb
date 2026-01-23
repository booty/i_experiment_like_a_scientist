# frozen_string_literal: true

# Algorithm
# for i = 2 to sqrt n
#   (so if n==625 then 2 to 25)
# if n is evenly divisible by i, then add i and n/i to results
# opt: if n is odd, we can start at 3 and increment by 2

def factors(n)
  return [] unless n.is_a?(Integer)
  return [] unless n.positive?

  limit = Math.sqrt(n).to_i

  low  = []
  high = []

  i = 1
  step = n.odd? ? 2 : 1

  while i <= limit
    if (n % i).zero?
      low << i
      other = n / i
      high << other unless other == i # avoid duplicate only for perfect squares
    end
    i += step
  end

  low + high.reverse
end

pp factors(625)
pp factors(9)
pp factors(144)
pp factors(100_000_000_000_000_000)

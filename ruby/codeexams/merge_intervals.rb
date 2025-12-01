# frozen_string_literal: true

# Merge Intervals
#
# Assumption (the usual one in interview problems):
# 	•	Intervals are closed (e.g. [1,4] includes both 1 and 4).
# 	•	Intervals that touch at endpoints are considered overlapping
# 	  •	[1,4] and [4,5] ⇒ [1,5]
#
# input: [[1,3], [2,6], [8,10], [15,18]]
# expected output: [[1,6], [8,10], [15,18]]
# Reason: [1,3] and [2,6] overlap and merge to [1,6]. Others don’t overlap.
#
# input: [[1,4], [4,5]]
# expected output: [[1,5]]
#
# input: [[1,2], [3,4], [5,6]]
# output: [[1,2], [3,4], [5,6]]
#
# input: [[1,10], [2,3], [4,8]]
# output: [[1,10]]
#
# input: [[2,3], [1,10], [5,7], [10,10]]
# output: [[1,10]]
#
# input: [[5,7], [1,3], [2,4]]
# output: [[1,4], [5,7]]
#
# input: [[6,8], [1,9], [2,4], [4,7]]
#
#
#

def merge_intervals(input)
  return input if input.length < 2

  sorted = input.sort_by { |x| x[0] }
  result = []

  curr = nil

  sorted.each_with_index do |a, idx|
    # puts("idx:#{idx} a:#{a} curr:#{curr}")

    if idx.zero?
      curr = a.dup
      next
    end

    if a[0] <= curr[1]
      # puts("  on a roll")
      curr[0] = [curr[0], a[0]].min
      curr[1] = [curr[1], a[1]].max
    else
      # puts("  discontinuity, will push #{curr}")
      result << curr
      curr = a.dup
    end
    if idx == input.length - 1
      # puts("  this is the end")
      result << curr
    end
  end
  result
end

test_cases = [
  {
    input: [[1, 3], [2, 6], [8, 10], [15, 18]],
    output: [[1, 6], [8, 10], [15, 18]],
    use: true
  },
  {
    input: [[1, 2], [3, 4], [5, 6]],
    output: [[1, 2], [3, 4], [5, 6]],
    use: true
  },
  {
    input: [[1, 2], [2, 3], [3, 4], [5, 6]],
    output: [[1, 4], [5, 6]],
    use: true
  },
  {
    # nested
    input: [[1, 10], [2, 3], [4, 8]],
    output: [[1, 10]]
  },
  {
    # need to sort
    input: [[2, 3], [1, 10], [5, 7], [10, 10]],
    output: [[1, 10]]
  },
  {
    # need to sort
    input: [[5, 7], [1, 3], [2, 4]],
    output: [[1, 4], [5, 7]]
  },
  {
    input: [[6, 8], [1, 9], [2, 4], [4, 7]],
    output: [[1, 9]]
  },
  {
    input: [[1, 9]],
    output: [[1, 9]]
  },
  {
    input: [],
    output: []
  },
  {
    input: [[1, 1], [1, 2], [3, 3]],
    output: [[1, 2], [3, 3]]
  },
  {
    input: [[1, 10], [2, 3], [4, 5], [9, 12]],
    output: [[1, 12]]
  },
  {
    input: [[1, 10], [2, 20], [3, 15]],
    output: [[1, 20]]
  }
]

test_cases.each do |tc|
  # next unless tc[:use]

  puts("\n---- Case: #{tc[:input]} ----")
  # Make sure we're not mutating
  tc[:input].freeze
  tc[:input].each(&:freeze)
  actual = merge_intervals(tc[:input])

  pass = actual == tc[:output]
  puts("expected: #{tc[:output]}")
  puts("actual: #{actual} #{tc[:output] == actual ? '✅' : '❌'}")
end

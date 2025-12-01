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

  streak_start = 0
  i = 1

  # puts("sorted:#{sorted}")

  while i <= input.length
    a_current = sorted[i]
    a_prev = sorted[i - 1]
    a_start = sorted[streak_start]

    # otherwise, merge sorted[streak_start] and sorted[i] and push it to the result
    # puts("i:#{i} a_start:#{a_start} a_prev:#{a_prev} a_current:#{a_current} streak_start=#{streak_start}")
    unless a_current && ((a_current[0] <= a_prev[1]) || (a_current[1] <= a_start[1]))
      result << [a_start[0], [a_prev[1], a_start[1]].max]
      streak_start = i
    end
    i += 1
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
  }
]

test_cases.each do |tc|
  # next unless tc[:use]

  puts("\n---- Case: #{tc[:input]} ----")
  actual = merge_intervals(tc[:input])
  pass = actual == tc[:output]
  puts("expected: #{tc[:output]}")
  puts("actual: #{actual} #{tc[:output] == actual ? '✅' : '❌'}")
end

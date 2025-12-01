# frozen_string_literal: true

# Sliding Window Maximum
#
# Given an array and window size k, return the max for each window.
#
#
# sliding_max([1,3,-1,-3,5,3,6,7], 3)
# => [3,3,5,5,6,7]
#
# Constraints:
# 	•	O(n) time required
# 	•	Follow-ups:
# 	•	Implement with a monotonic deque
# 	•	Memory trade-off analysis

def sliding_max_easy(nums, size)
  raise "Window size exceeds list size" if size > nums.length

  result = []
  (size - 1).upto(nums.length - 1) do |upper|
    lower = upper - size + 1
    result << nums[lower..upper].max
  end
  result
end

def sliding_max_naive(nums, size)
  raise "Window size exceeds list size" if size > nums.length

  result = []
  (size - 1).upto(nums.length - 1) do |upper|
    lower = upper - size + 1

    max = nums[lower]
    (lower + 1).upto(upper) do |i|
      max = nums[i] if nums[i] > max
    end

    result << max
  end
  result
end

# NOTE: provided by ChatGPT
def sliding_max_deque(nums, size)
  raise ArgumentError, "window size must be positive" if size <= 0
  raise ArgumentError, "window size exceeds list size" if size > nums.length

  deque = [] # will store indices
  result = []

  nums.each_with_index do |value, i|
    # 1. Remove indices that are out of the current window
    if !deque.empty? && deque.first <= i - size
      deque.shift
    end

    # 2. Maintain decreasing order in deque by value
    while !deque.empty? && nums[deque.last] <= value
      deque.pop
    end

    # 3. Push current index
    deque << i

    # 4. Record result once the first full window is formed
    if i >= size - 1
      result << nums[deque.first]
    end
  end

  result
end

correct_answer = [3, 3, 5, 5, 6, 7]
nums = [1, 3, -1, -3, 5, 3, 6, 7]
window = 3

result_easy = sliding_max_easy(nums, window)
puts("result_easy: #{result_easy} (#{correct_answer == result_easy})")

result_naive = sliding_max_naive(nums, window)
puts("result_naive: #{result_naive} (#{correct_answer == result_naive})")

result_deque = sliding_max_naive(nums, window)
puts("result_deque: #{result_deque} (#{correct_answer == result_deque})")
# => [3,3,5,5,6,7]

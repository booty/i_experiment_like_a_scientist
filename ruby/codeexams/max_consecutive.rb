# frozen_string_literal: true

def longest_unique_substring(s)
  return 0 if s.length == 0
  return 1 if s.length == 1

  left = 0
  right = 0
  last_seen = {}
  max = 1

  while right < s.length
    c = s[right]

    c_last_seen = last_seen[c]

    # puts "l:#{left} r:#{right} window:#{s[left..right]}"

    if c_last_seen && c_last_seen >= left
      left += 1
    else
      dist = right - left + 1
      max = dist if dist > max
      last_seen[c] = right
      right += 1
    end

  end
  max
end

samples = {
  "" => 0,
  "a" => 1,
  "aa" => 1,
  "abcabcbb" => 3,
  "bbbbb" => 1,
  "pwwkew" => 3,
  "abba" => 2,
  "dvdf" => 3,
  "tmmzuxt" => 5,
  "abcbde" => 4,
  "abcdef" => 6
}

samples_mini = {
  "abba" => 2,
  "dvdf" => 3,
  "abcbde" => 4
  # "tmmzuxt" => 5
}

samples.each do |input, expected|
  actual = longest_unique_substring(input)
  puts("input: #{input}")
  puts("\tactual: #{actual}")
  puts("\texpected?: #{expected} #{actual == expected ? '✅' : '❌'}")
end

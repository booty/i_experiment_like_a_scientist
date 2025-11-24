# frozen_string_literal: true

require "benchmark/ips"

def split_words_regex(str)
  str.scan(/\p{Letter}+|\p{Number}+/)
end

def split_words_slice(str)
  boundaries = []

  last_was_alpha = nil
  0.upto(str.length - 1) do |i|
    c = str[i]
    code = c.ord
    is_alpha = code.between?(65, 90) || code.between?(97, 122)

    # puts("i:#{i} c:#{c} is_alpha:#{is_alpha} last_was_alpha:#{last_was_alpha}")
    boundaries.push(i) if i.zero? || (is_alpha && !last_was_alpha) || (!is_alpha && last_was_alpha)

    last_was_alpha = is_alpha
  end
  boundaries.each_with_index.map do |start, idx|
    endpos = boundaries[idx + 1]
    endpos = endpos ? endpos - 1 : str.length
    str[start..endpos]
  end
end

def split_words_buffer(str)
  result = []
  buffer = +""
  last_was_alpha = nil
  str.each_char do |c|
    is_alpha = c.ord.between?(65, 90) || c.ord.between?(97, 122)

    if last_was_alpha.nil? || (is_alpha == last_was_alpha)
      buffer << c
    else
      result << buffer
      buffer = +c
    end

    last_was_alpha = is_alpha
  end
  result << buffer
  result
end

def split_words_buffer_regex(str)
  result = []
  buffer = +""
  last_was_alpha = nil
  str.each_char do |c|
    is_alpha = c.match?(/\p{Alpha}/)

    if last_was_alpha.nil? || (is_alpha == last_was_alpha)
      buffer << c
    else
      result << buffer
      buffer = +c
    end

    last_was_alpha = is_alpha
  end
  result << buffer
  result
end

base_string = "ABC123DEF456"
Benchmark.ips do |x|
  x.config(warmup: 0.25, time: 2)

  [1, 10, 100, 1000, 10_000].each do |string_multiplier|
    test_string = base_string * string_multiplier
    x.report("split_words_regex (string length: #{test_string.length})") do
      split_words_regex(test_string)
    end
    x.report("split_words_slice (string length: #{test_string.length})") do
      split_words_slice(test_string)
    end
    x.report("split_words_buffer (string length: #{test_string.length})") do
      split_words_buffer(test_string)
    end
    x.report("split_words_buffer_regeex (string length: #{test_string.length})") do
      split_words_buffer_regex(test_string)
    end
  end
end

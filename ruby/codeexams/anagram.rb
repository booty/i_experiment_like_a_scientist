# frozen_string_literal: true

# This Kata was posted as the problem to be solved in a “self-documenting code contest”.
#
# The results of the code contest can be found here:
# http://selfexplanatorycode.blogspot.com/2008/09/results.html
#
# Problem Description
#
# Step 1
#
# Write a program that generates all two-word anagrams of the string
# “documenting”. You must focus on the readability of your code, and
# you must not include any kind of documentations to it. The goal is
# to create a code that everybody can read and understand easily.
#
# Here’s a word list you might want to use.
# https://codingdojo.org/kata/word_list.txt
#
# Step 2
#
# Try to improve the performance of your solution but keep in mind that making it faster affects readability.
# Continue to focus on readability first.

def get_wordlist(path)
  File.readlines(path).map(&:chomp).sort
end

def subtract_hash(h1, h2)
  h2.each_with_object(h1.dup) do |item, result|
    h2_key = item[0]
    h2_value = item[1]
    result[h2_key] = result[h2_key].to_i - h2_value
  end
end

DEBUG_COMBOS = [%w[af rt], %w[rt af]]

def find_two_word_anagrams_v2(word:, wordlist:)
  start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  results = Set.new

  wordlist_length = wordlist.length
  word_length = word.length
  word_chars = word.chars
  word_tally = word_chars.tally

  inner_loop_start_count = 0
  inner_loop_end_count = 0
  inner_loop_middle_count = 0
  # debug = false

  wordlist_filtered_sorted = wordlist.select { |x| x.length < word_length }.sort_by(&:length)

  wordlist_filtered_sorted.each_with_index do |wordlist_word, outer_index|
    if outer_index % 1000 == 0
      end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      elapsed = end_time - start_time
      puts("outer loop:#{outer_index}/#{wordlist_filtered_sorted.length} elapsed:#{elapsed.round(4)} seconds")
    end
    break if wordlist_word.length > word_length / 2

    # next if answer_cache.include?(wordlist_word)

    wordlist_word_chars = wordlist_word.chars
    # next if (wordlist_word_chars - word_chars).any? # TODO: helpful?

    wordlist_word_tally = wordlist_word_chars.tally

    remaining_letters_tally = subtract_hash(word_tally, wordlist_word_tally)

    next if remaining_letters_tally.any? { |k, v| v.negative? }

    next unless remaining_letters_tally.any? { |k, v| v.positive? }

    # puts "wordlist_word:#{wordlist_word} remaining_letters_tally:#{remaining_letters_tally}"

    remaining_letters_count = remaining_letters_tally.values.sum
    wordlist_filtered_sorted.each do |wordlist_second_word|
      inner_loop_start_count += 1
      # debug = DEBUG_COMBOS.include?([wordlist_word,
      #                                wordlist_second_word]) || DEBUG_COMBOS.include?([wordlist_second_word,
      #                                                                                 wordlist_word])
      break if wordlist_second_word.length > remaining_letters_count
      next unless wordlist_second_word.length == remaining_letters_count

      inner_loop_middle_count += 1
      remaining_letters_tally2 = subtract_hash(remaining_letters_tally, wordlist_second_word.chars.tally)

      # puts "  wordlist_second_word:#{wordlist_second_word} answer_cache:#{answer_cache}" if debug

      next unless remaining_letters_tally2.all? { |k, v| v.zero? }

      results.add([wordlist_word, wordlist_second_word].sort)
      # answer_cache.add(wordlist_second_word)
      inner_loop_end_count += 1
    end
  end
  puts("inner_loop_start_count:#{inner_loop_start_count} inner_loop_middle_count:#{inner_loop_middle_count} inner_loop_end_count:#{inner_loop_end_count}")
  results
end

wordlist = get_wordlist("words_alpha_sorted.txt")
puts "Got #{wordlist.length} entries in the wordlist"

%w[laptop].each do |word|
  start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  answer = find_two_word_anagrams_v2(word:, wordlist:)
  puts "Found #{answer.length} results: #{answer.sort}"

  end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  elapsed = end_time - start_time
  puts "Elapsed time for \"#{word}\": #{elapsed.round(4)} seconds"
end

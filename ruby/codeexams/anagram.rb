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

DEBUG_WORDS = %w[lap top]

def tally(word:, tallycache:)
  tallycache[word] ||= word.chars.tally
end

def find_two_word_anagrams_v2(word:, wordlist:)
  word = word.downcase
  start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  results = Set.new

  wordlist_length = wordlist.length
  word_length = word.length
  word_chars = word.chars
  word_tally = word_chars.tally
  tallycache = {}
  debug = false

  wordlist_filtered_sorted =
    wordlist
    .select { |x| x.length < word_length }
    .map(&:downcase)
    .sort_by(&:length)

  words_by_length = wordlist_filtered_sorted.group_by(&:length)

  wordlist_filtered_sorted.each_with_index do |answer1, outer_index|
    if outer_index % 1000 == 0
      end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      elapsed = end_time - start_time
      puts("outer loop:#{outer_index}/#{wordlist_filtered_sorted.length} elapsed:#{elapsed.round(4)} seconds")
    end
    break if answer1.length > word_length / 2

    wordlist_word_tally = tally(word: answer1, tallycache:) # wordlist_word_chars.tally

    remaining_letters_tally = subtract_hash(word_tally, wordlist_word_tally)

    next if remaining_letters_tally.any? { |k, v| v.negative? }

    next unless remaining_letters_tally.any? { |k, v| v.positive? }

    remaining_letters_count = remaining_letters_tally.values.sum
    (words_by_length[remaining_letters_count] || []).each do |answer2|
      debug = DEBUG_WORDS.include?(answer2)

      remaining_letters_tally2 = subtract_hash(remaining_letters_tally, tally(word: answer2, tallycache:))

      # puts "  outer_index:#{outer_index} answer1:#{answer1} answer2:#{answer2}" if debug

      next unless remaining_letters_tally2.all? { |k, v| v.zero? }

      # puts "  success:#{[answer1, answer2]}"
      results.add([answer1, answer2].sort)
    end
  end
  results.sort
end

wordlist = get_wordlist("words_alpha_sorted.txt")
puts "Got #{wordlist.length} entries in the wordlist"

%w[documenting].each do |word|
  start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  answer = find_two_word_anagrams_v2(word:, wordlist:)
  puts "Found #{answer.length} results: #{answer}"

  end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  elapsed = end_time - start_time
  puts "Elapsed time for \"#{word}\": #{elapsed.round(4)} seconds"
end

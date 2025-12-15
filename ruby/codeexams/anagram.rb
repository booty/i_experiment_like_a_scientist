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

def get_wordlist_by_length(path)
  File.readlines(path).map(&:chomp).sort_by(&:length).map(&:downcase)
end

def tally(word:, tallycache:)
  tallycache[word] ||= word.chars.tally
end

# converts a word to a histogram stored in a standard ruby array
def tally_array(word:, tally_array_cache:)
  return tally_array_cache[word] if tally_array_cache[word]

  result = Array.new(26) { 0 }
  word.chars.each do |c|
    result[c.ord - 97] += 1
  rescue StandardError => e
    puts "failed to calculate ord for #{c}"
    raise e
  end
  tally_array_cache[word] = result
end

RANGE = (0..25)
def subtract_tally_arrays(ary1, ary2)
  result = Array.new(26)
  RANGE.each do |idx|
    return nil if (result[idx] = ary1[idx] - ary2[idx]).negative?
  end
  result
end

def find_two_word_anagrams_v2(word:, wordlist:)
  word = word.downcase
  results = Set.new

  word_length = word.length
  tally_array_cache = {}
  word_tally = tally_array(word:, tally_array_cache:)
  debug = false

  wordlist_filtered_sorted =
    wordlist
    .select { |x| x.length < word_length }.sort_by { |x| x.length }

  words_by_length = wordlist_filtered_sorted.group_by(&:length)

  puts("Will examine #{wordlist_filtered_sorted.length} words in wordlist_filtered_sorted")
  # puts(wordlist_filtered_sorted.join(" "))

  wordlist_filtered_sorted.each_with_index do |answer1, outer_index|
    # if outer_index % 1000 == 0
    #   end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    #   elapsed = end_time - start_time
    #   puts("outer loop:#{outer_index}/#{wordlist_filtered_sorted.length} elapsed:#{elapsed.round(4)} seconds")
    # end
    # debug = answer1 == "lap"
    # puts("answer1: #{answer1}") if debug
    break if answer1.length > word_length / 2

    answer1_tally = tally_array(word: answer1, tally_array_cache:)

    # puts("answer1_tally:#{answer1_tally}") if debug

    remaining_letters_tally = subtract_tally_arrays(word_tally, answer1_tally)

    next unless remaining_letters_tally && remaining_letters_tally.any?(&:positive?)

    remaining_letters_count = remaining_letters_tally.sum
    (words_by_length[remaining_letters_count] || []).each do |answer2|
      # puts "answer2: #{answer2}" if debug
      answer_2_tally = tally_array(word: answer2, tally_array_cache:)
      results.add([answer1, answer2].sort) if remaining_letters_tally == answer_2_tally
    end
  end
  results.sort
end

wordlist = get_wordlist_by_length("words_alpha_sorted.txt")
puts "Got #{wordlist.length} entries in the wordlist"

%w[documenting].each do |word|
  start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  answer = find_two_word_anagrams_v2(word:, wordlist:)
  puts "Found #{answer.length} results: #{answer}"

  end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  elapsed = end_time - start_time
  puts "Elapsed time for \"#{word}\": #{elapsed.round(4)} seconds"
end

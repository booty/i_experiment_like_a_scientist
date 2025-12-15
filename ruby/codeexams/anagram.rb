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

def letter_count_tally(word:, tally_cache:)
  return tally_cache[word] if tally_cache[word]

  stringbuffer = "\x00" * 26
  stringbuffer.force_encoding(Encoding::BINARY)

  word.chars.each do |c|
    pos = c.ord - 97
    stringbuffer.setbyte(pos, stringbuffer.getbyte(pos) + 1)
  end

  tally_cache[word] = stringbuffer
end

def remaining_letter_count_tally(stringbuffer1, stringbuffer2)
  stringbuffer_result = nil

  i = 0
  while i < 26
    current_value = stringbuffer1.getbyte(i) - stringbuffer2.getbyte(i)
    return if current_value.negative?

    stringbuffer_result ||= "\0".b * 26

    stringbuffer_result.setbyte(i, current_value)
    i += 1
  end
  stringbuffer_result
end

def find_two_word_anagrams(word:, wordlist:)
  word = word.downcase

  results = Set.new
  word_length = word.length
  tally_cache = {}
  word_tally = letter_count_tally(word:, tally_cache:)

  candidates_sorted_by_length =
    wordlist
    .select { |x| x.length < word_length }
  # .sort_by(&:length)

  candidates_grouped_by_length = candidates_sorted_by_length.group_by(&:length)

  candidates_sorted_by_length.each_with_index do |answer1, outer_index|
    break if answer1.length > word_length / 2

    answer1_tally = letter_count_tally(word: answer1, tally_cache:)

    remaining_letters_tally = remaining_letter_count_tally(word_tally, answer1_tally)

    next unless remaining_letters_tally

    remaining_letters_count = remaining_letters_tally.sum

    next unless remaining_letters_count.positive?

    (candidates_grouped_by_length[remaining_letters_count] || []).each do |answer2|
      answer_2_tally = letter_count_tally(word: answer2, tally_cache:)
      results.add([answer1, answer2].sort) if remaining_letters_tally == answer_2_tally
    end
  end
  results.sort
end

wordlist = get_wordlist_by_length("words_alpha_sorted.txt")
puts "Got #{wordlist.length} entries in the wordlist"

%w[documenting].each do |word|
  start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  answer = find_two_word_anagrams(word:, wordlist:)
  puts "Found #{answer.length} results: #{answer}"

  end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  elapsed = end_time - start_time
  puts "Elapsed time for \"#{word}\": #{elapsed.round(4)} seconds"
end

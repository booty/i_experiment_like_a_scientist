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

require "stackprof"

WORDLIST_PATH = "words_alpha_sorted.txt"

def perf_time
  Process.clock_gettime(Process::CLOCK_MONOTONIC)
end

def get_wordlist_by_length(path:, max_length:)
  words = []

  File.foreach(path) do |line|
    word = line.chomp
    next if word.length > max_length

    words << [word.downcase, letter_count_tally(word.downcase)]
  end

  words.sort_by! { |word, _tally| word.length }
end

def letter_count_tally(word)
  stringbuffer = "\x00" * 26
  stringbuffer.force_encoding(Encoding::BINARY)

  word.chars.each do |c|
    pos = c.ord - 97
    stringbuffer.setbyte(pos, stringbuffer.getbyte(pos) + 1)
  end

  stringbuffer
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

def find_two_word_anagrams(word:)
  word = word.downcase

  results = Set.new
  word_length = word.length
  word_tally = letter_count_tally(word).freeze

  candidates_sorted_by_length = get_wordlist_by_length(path: WORDLIST_PATH, max_length: word_length - 1)

  candidates_grouped_by_length = candidates_sorted_by_length.group_by { |x| x[0].length }

  candidates_sorted_by_length.each_with_index do |(answer1, answer1_tally), _outer_index|
    break if answer1.length > word_length / 2

    remaining_letters_tally = remaining_letter_count_tally(word_tally, answer1_tally)

    next unless remaining_letters_tally

    # remaining_letters_count = remaining_letters_tally.sum
    remaining_letters_count = word.length - answer1.length

    next unless remaining_letters_count.positive?

    (candidates_grouped_by_length[remaining_letters_count] || []).each do |(answer2, answer2_tally)|
      results.add([answer1, answer2].sort) if remaining_letters_tally == answer2_tally
    end
  end
  results.sort
end

%w[documenting].each do |word|
  start_time = perf_time

  answer = find_two_word_anagrams(word:)
  puts "Found #{answer.length} results: #{answer}"

  elapsed = perf_time - start_time
  puts "Elapsed time for \"#{word}\": #{elapsed.round(4)} seconds"
end

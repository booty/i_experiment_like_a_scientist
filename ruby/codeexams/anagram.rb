# frozen_string_literal: true

require "prettyprint"

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

def string_exists_in_wordlist(wordlist:, target:)
  wordlist.bsearch { |x| x >= target } == target
end

def find_anagrams(chars:, wordlist:, anagram_cache:)
  cached_result = anagram_cache[chars]
  return cached_result unless cached_result.nil?

  result = chars.permutation.each_with_object([]) do |perm, result|
    joined = perm.join
    result << joined if string_exists_in_wordlist(wordlist:, target: joined)
  end

  anagram_cache[chars] = result
end

def find_two_word_anagrams(chars:, wordlist:)
  anagram_cache = {}

  chars.permutation.each_with_object(Set.new) do |perm, results|
    0.upto(perm.length - 2) do |cut_after|
      slice1 = perm[0..cut_after]
      slice2 = perm[(cut_after + 1)..]

      anagrams_for_slice1 = find_anagrams(chars: slice1, wordlist:, anagram_cache:)

      next if anagrams_for_slice1.empty?

      anagrams_for_slice2 = find_anagrams(chars: slice2, wordlist:, anagram_cache:)

      next if anagrams_for_slice2.empty?

      next if slice2.length > slice1.length

      foo = anagrams_for_slice1.product(anagrams_for_slice2).map(&:sort)

      # puts("foo:#{foo}")

      results.merge(foo)
    end
  end
end

wordlist = get_wordlist("words_alpha_sorted.txt")
puts "Got #{wordlist.length} entries in the wordlist"

%w[laptop].each do |word|
  start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  answer = find_two_word_anagrams(chars: word.chars, wordlist:)
  puts "Found #{answer.length} results: #{answer.sort}"

  end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  elapsed = end_time - start_time
  puts "Elapsed time for \"#{word}\": #{elapsed.round(4)} seconds"
end

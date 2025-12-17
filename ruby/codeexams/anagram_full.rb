# frozen_string_literal: true

WORDLIST_PATH = "words-tiny.txt"

# assumes both buffers are the same size
# optimization: exits early and returns nil if anything is negative
def subtract_buffers(stringbuf1, stringbuf2)
  result = String.new(capacity: stringbuf1.bytesize)
  i = 0

  stringbuf1.each_byte do |x|
    value = (x - stringbuf2.getbyte(i))
    return nil if value.negative?

    result << value
    i += 1
  end

  result
end

def tally(word)
  stringbuffer = "\x00" * 26
  stringbuffer.force_encoding(Encoding::BINARY)

  word.each_byte do |b|
    pos = b - 97
    stringbuffer.setbyte(pos, stringbuffer.getbyte(pos) + 1)
  end

  stringbuffer
end

# returns list of words, grouped by length and tally
def wordlist(path:)
  result = Hash.new { |h, k| h[k] = {} }
  File.foreach(path) do |line|
    word = line.chomp.downcase
    tally = tally(word)
    result[word.length][tally] = word
  end
  result
end

def debug_buffer_to_string(stringbuf)
  output = +""
  stringbuf.each_byte.with_index do |b, i|
    next if b.zero?

    output << ((i + 97).chr * b)
  end
  output
end

def find_anagrams(tally:, wordlist:, debug_depth: 0)
  results = []
  indent = "  " * debug_depth
  indent2 = "  " * (debug_depth + 1)

  # binding.irb if debug_depth > 0

  # iterate over the wordlist for lengths 1..(remaining_tally/2)
  wordlist.each do |word_length, tally_hash|
    next unless word_length <= tally.sum

    debug_word = debug_buffer_to_string(tally)

    # puts("#{indent}remaining letters:#{debug_word} Looking at candidates w/ length: #{word_length} depth:#{debug_depth}")

    tally_hash.each do |anagram_tally, anagram_word|
      remaining_tally = subtract_buffers(tally, anagram_tally)

      remaining_tally_sum = remaining_tally&.sum

      next if remaining_tally.nil?

      print("#{indent2}anagram_word:#{anagram_word} anagram_tally.length:#{anagram_tally.length} remaining:#{remaining_tally&.sum || 'fail'}")

      if remaining_tally_sum.zero?
        puts " SUCCESS!"
        results << [anagram_word]
      else
        puts
        temp_results = find_anagrams(tally: remaining_tally, wordlist:, debug_depth: debug_depth + 1)
        # binding.irb if temp_results.any?
        temp_results.each do |tr|
          results << ([anagram_word] + tr)
        end
      end
    end
  end
  puts("#{indent2}Returning #{results} for depth: #{debug_depth}")
  results
end

# puts debug_buffer_to_string(tally("ballbanger"))

word = "catdog"
results = find_anagrams(tally: tally(word), wordlist: wordlist(path: WORDLIST_PATH))
# puts(results.map { |x| debug_buffer_to_string(x) })
results.each do |result|
  pp result
end

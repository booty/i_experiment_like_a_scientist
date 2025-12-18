# frozen_string_literal: true

WORDLIST_PATH = "google-10000-english.txt"
SHOW_PROGRESS = true
# Kludge: all the wordlists I found included a lot of bizarre 1 and 2 letter words
LEGAL_1_LETTER_WORDS = %w[a i]
LEGAL_2_LETTER_WORDS = %w[ab ad ah am an as at aw ax be by do eh el em ew ex gi go ha he hi hm ho id if in is it ki la
                          lo ma me mi mm mo mu my na ne no nu od oe of oh oi ok om on op]

# assumes both buffers are the same size
# optimization: exits early and returns nil if anything is negative
# NOTE: returns a new remaining tally buffer, or nil if the subtraction would go negative
def subtract_buffers(stringbuf1, stringbuf2)
  result = String.new(capacity: stringbuf1.bytesize)
  i = 0

  stringbuf1.each_byte do |x|
    value = x - stringbuf2.getbyte(i)
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

# returns hash:
#   length(Integer) => array of [tally(String), word(String)] pairs
# where each tally may map to multiple words
def wordlist(path:)
  grouped = Hash.new { |h, k| h[k] = Hash.new { |hh, kk| hh[kk] = [] } }

  File.foreach(path) do |line|
    word = line.chomp.downcase
    next if word.length == 1 && !LEGAL_1_LETTER_WORDS.include?(word)
    next if word.length == 2 && !LEGAL_2_LETTER_WORDS.include?(word)

    t = tally(word)
    grouped[word.length][t] << word
  end

  # Flatten to an array for faster iteration, and sort words for deterministic ordering.
  # This also gives us a consistent order for the duplicate-avoidance rule in find_anagrams.
  grouped.transform_values do |tally_to_words|
    tally_to_words.flat_map do |t, words|
      words.sort.map { |w| [t, w] }
    end
  end
end

def debug_buffer_to_string(stringbuf)
  output = +""
  stringbuf.each_byte.with_index do |b, i|
    next if b.zero?

    output << ((i + 97).chr * b)
  end
  output
end

def perf_time
  Process.clock_gettime(Process::CLOCK_MONOTONIC)
end

def find_anagrams(tally:, remaining_len:, wordlist:, last_word: "", memo: {})
  key = [tally, last_word]
  cached = memo[key]
  return cached if cached

  # Base case: no letters left
  if remaining_len.zero?
    memo[key] = [[]]
    return memo[key]
  end

  results = []

  # Only consider candidate word lengths that fit.
  wordlist.each do |word_length, entries|
    next if word_length > remaining_len

    entries.each do |candidate_tally, candidate_word|
      # Enforce canonical order to avoid duplicates (permutations of the same set of words).
      next if candidate_word < last_word

      remaining_tally = subtract_buffers(tally, candidate_tally)
      next unless remaining_tally

      if word_length == remaining_len
        results << [candidate_word]
      else
        sub_results = find_anagrams(
          tally: remaining_tally,
          remaining_len: remaining_len - word_length,
          wordlist: wordlist,
          last_word: candidate_word,
          memo: memo
        )

        sub_results.each do |sr|
          results << ([candidate_word] + sr)
        end
      end
    end
  end

  memo[key] = results
end

start = perf_time
word = "face fucker"
word = word.delete(" ")
wl = wordlist(path: WORDLIST_PATH)
results = find_anagrams(tally: tally(word), remaining_len: word.length, wordlist: wl)
puts("---[ Results (#{results.length}) ]\b")
results.sort.each do |result|
  puts result.join(" ")
end
duration = perf_time - start
if duration < 1
  puts "\bTook #{(duration * 1000).round(4)}ms for #{results.length} results."
else
  puts "\bTook #{duration.round(4)}s for #{results.length} results."
end

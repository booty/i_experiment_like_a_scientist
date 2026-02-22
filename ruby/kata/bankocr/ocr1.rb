# frozen_string_literal: true


class OcrDigitResult
  attr_reader :raw
  attr_reader :digit
  attr_reader :status

  def initialize(raw:, digit:, status:)
    @raw = raw
    @digit = digit
    @status = status
  end

  def to_s
    "OcrDigitResult(digit: #{digit}, status: #{status})"
  end
end

class OcrResult
  attr_reader :digits
  attr_reader :status

  def initialize(ocr_digit_results: [])
    @digits = ocr_digit_results

    @status = :ok
    if ocr_digit_results.any? { |d| d.status != :ok }
      @status = :err
    end
  end

  def to_i
    if status == :ok
      digits.map(&:digit).join.to_i
    else
      nil
    end
  end

  def to_str
    digits.map do |d|
      if d.status==:ok
        d.digit
      else
        "?"
      end
    end.join
  end

  def to_s
    "OcrResult(to_i:#{to_i} to_str:#{to_str} status:#{status})"
  end
end

class Ocr
  RAW_CANON_DIGITS =
  " _     _  _     _  _  _  _  _ \n" +
  "| |  | _| _||_||_ |_   ||_||_|\n" +
  "|_|  ||_  _|  | _||_|  ||_| _|\n"

  class MalformedInput < StandardError; end


  def self.parse(input)
    normalized = normalize_lines(input)
    validate_normalized_lines!(normalized)
    OcrResult.new
  end

  def self.normalized_lines(input)
    input
      .lines
      .map { |line| line.gsub(/\n/,"") }
      .reject(&:empty?)
  end

  def self.validate_normalized_lines!(lines)
    lengths = lines.map(&:length)
    unless lengths.uniq.one?
      raise MalformedInput.new("All lines of text should be the same length (lengths were #{lengths.join(",")})")
    end

    unless lines.length == 3
      raise MalformedInput.new("Input should be 3 lines long")
    end

    unless (lines[0].length % 3).zero?
      raise MalformedInput.new("Each line length should be a multiple of 3")
    end
  end

  def self.extract_chars(str)
    lines = normalized_lines(str)
    validate_normalized_lines!(lines)

    line_length = lines.first.length
    num_ocr_chars = line_length / 3
    result = Array.new(num_ocr_chars) { Array.new }

    # puts("lines:\n#{lines.join("\n")}\n")


    0.upto(num_ocr_chars-1) do |char_num|
      offset = char_num * 3
      0.upto(2) do |linenum|
        stuff = lines[linenum][offset..offset+2]
        # puts "char_num:#{char_num} linenum:#{linenum} offset:#{offset} stuff:#{stuff}"
        result[char_num] << stuff
      end
    end

    result
  end

  def self.string_distance(str1, str2)
    return 0 if str1==str2
    return 999 if str1.length != str2.length
    distance = 0
    str1.length.times do |i|
      distance += 1 if str1[i] != str2[i]
    end
    distance
  end

  def self.checksum(ints)
    return nil unless ints.length == 9
  end

  def self.resolve_raw_digit(str)
    canon_char = @@canon_digits[str]
    if canon_char
      return OcrDigitResult.new(raw: str, digit: canon_char, status: :ok)
    end

    candidates = @@canon_digits.select do |k,v|
      dist = string_distance(k.join, str.join)
      # puts("key:#{k} val:#{v} dist:#{dist}")
      dist == 1
    end

    if candidates.length==1
      return OcrDigitResult.new(raw: str, digit: candidates.values[0], status: :ok)
    end

    if candidates.length.zero?
      return OcrDigitResult.new(raw: str, digit: nil, status: :illegible)
    end

    # puts "well that's ambiguous"
    return OcrDigitResult.new(raw: str, digit: nil, status: :ambiguous)
  end

  def self.ocr(input)
    # todo: ensure input is a string?
    # extract the raw chars
    @@canon_digits ||= extract_chars(RAW_CANON_DIGITS).each_with_index.to_h
    raw_digits = extract_chars(input)


    # do "OCR" on each individual char, putting the results into an array
    results = []
    raw_digits.each do |rd|
      results << resolve_raw_digit(rd)

    end
    # return the result object
    OcrResult.new(ocr_digit_results: results)
  end
end

TEST_DIGITS =
  " _  _  _  _     _  _     _  _ \n" +
  "  ||_||_|| |  | _| _||_||_ |_ \n" +
  "  ||_| _||_|  ||_  _|  | _||_|\n"

TEST_DIGITS_FIXABLE =
  " _  _  _  _     _  _     _  _ \n" +
  "  a|_||_|| |  | _| _||_||_ |_ \n" +
  "  ||_| _||_|  ||_  _|  | _||_|\n"

TEST_DIGITS_AMBIGUOUS =
  " a  _  _  _     _  _     _  _ \n" +
  "  ||_||_|| |  | _| _||_||_ |_ \n" +
  "  ||_| _||_|  ||_  _|  | _||_|\n"
TEST_DIGITS_ILLEGIBLE =
  " _  _  _  _     _  _     _  _ \n" +
  "|  |_||_|| |  | _| _||_||_ |_ \n" +
  "| ||_| _||_|  ||_  _|  | _||_|\n"


good_result = Ocr.ocr(TEST_DIGITS)
puts good_result
bad_result = Ocr.ocr(TEST_DIGITS_FIXABLE)
puts bad_result
ambiguous_result = Ocr.ocr(TEST_DIGITS_AMBIGUOUS)
puts ambiguous_result
illegible_result = Ocr.ocr(TEST_DIGITS_ILLEGIBLE)
puts illegible_result

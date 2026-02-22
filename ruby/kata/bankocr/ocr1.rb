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
    if ocr_digit_results.any? { |d| d.status == :unrecognized }
      @status = :unrecognized
    end
  end

  def to_i
    if status == :ok
      digits.map(&:digit).join.to_i
    else
      nil
    end
  end

  def to_s
    "OcrResult(to_i: #{to_i}, status: #{status})"
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

    puts("lines:\n#{lines.join("\n")}\n")


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

  def self.chars_to_digits(input)
    # todo: ensure input is a string?
    # extract the raw chars
    @@canon_digits ||= extract_chars(RAW_CANON_DIGITS).each_with_index.to_h
    raw_digits = extract_chars(input)


    # do "OCR" on each individual char, putting the results into an array
    results = []
    raw_digits.each do |rd|
      canon_char = @@canon_digits[rd]
      if canon_char
        results << OcrDigitResult.new(raw: rd, digit: canon_char, status: :ok)
      else
        results << OcrDigitResult.new(raw: rd, digit: nil, status: :unrecognized)
      end
    end
    # return the result object
    OcrResult.new(ocr_digit_results: results)
  end
end

TEST_DIGITS =
  " _  _  _  _     _  _     _  _ \n" +
  "  ||_||_|| |  | _| _||_||_ |_ \n" +
  "  ||_| _||_|  ||_  _|  | _||_|\n"

result = Ocr.extract_chars(TEST_DIGITS)
fuck = Ocr.chars_to_digits(TEST_DIGITS)
puts fuck

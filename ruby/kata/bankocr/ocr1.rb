# frozen_string_literal: true

DIGITS = <<INPUT
 _     _  _     _  _  _  _  _
| |  | _| _||_||_ |_   ||_||_|
|_|  ||_  _|  | _||_|  ||_| _|
INPUT

TEST_INPUT = <<~INPUT
aaabbbccc
dddeeefff
ggghhhiii
INPUT

class OcrDigitResult
  attr_reader :digit
  attr_reader :result # ERR, ILL, OK

  def initialize(chars)

  end
end

class OcrResult
  attr_reader :digits
end

class Ocr
  class MalformedInput < StandardError; end

  def self.parse(input)
    normalized = normalize_lines(input)
    validate_normalized_lines!(normalized)
    OcrResult.new
  end

  def self.normalized_lines(input)
    input
      .lines
      .map(&:rstrip)
      .reject(&:empty?)
  end

  def self.validate_normalized_lines!(normalized_input)
    unless normalized_input.lines.map(&:rstrip).map(&:length).uniq.one?
      raise MalformedInput.new("All lines of text should be the same length")
    end

    unless normalized_input.lines.length == 3
      raise MalformedInput.new("Input should be 3 lines long")
    end

    unless (normalized_input.lines[0].strip.length % 3).zero?
      raise MalformedInput.new("Each line length should be a multiple of 3")
    end
  end

  def self.extract_digits(str)
    lines = normalized_lines(str)

    line_length = lines.first.length
    num_ocr_chars = line_length / 3
    result = Array.new(num_ocr_chars) { Array.new }

    puts("lines:\n#{lines.join("\n")}\n")

    0.upto(num_ocr_chars - 1) do |char_num|
      offset = char_num * 3
      0.upto(2) do |linenum|
        stuff = lines[linenum][offset..offset+2]
        puts "char_num:#{char_num} linenum:#{linenum} offset:#{offset} stuff:#{stuff}"
        result[char_num] << stuff
      end
    end

    result
  end
end

puts DIGITS

result = Ocr.extract_digits(DIGITS)
puts result[8].join("\n")

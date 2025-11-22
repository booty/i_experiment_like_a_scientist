# frozen_string_literal: true

class DSL
  TOKENIZE_REGEX = /"[^"]*"|\S+/ # handles quoted strings
  VALID_IDENTIFIER_REGEX = /\A[a-zA-Z]/

  def initialize
    @vars = {}
  end

  def execute(s)
    s.each_line do |line|
      tokens = tokenize_line(line.strip)
      next if skip?(tokens) # comment or blank?

      validate_line!(tokens)

      puts("tokens: #{tokens}")

      case tokens[0].downcase
      when "increment"
        @vars[tokens[1]] = @vars[tokens[1]] + tokens[3].to_i
      when "decrement"
        @vars[tokens[1]] = @vars[tokens[1]] - tokens[3].to_i
      when "set"
        @vars[tokens[1]] = tokens[3].to_i
      when "print"
        puts get_or_create_variable(tokens[1])
      end
    end
  end

  # private
  def get_or_create_variable(token)
    result = @vars[token]

    return result if result

    @vars[token] = 0
  end

  def skip?(line)
    true if line.length == 0 or line[0][0] == "#"
  end

  def validate_line!(tokens)
    true # todo
  end

  def tokenize_line(line)
    line.scan(TOKENIZE_REGEX)
  end

  def valid_string_literal?(identifier)
    identifier[0] == "\"" && identifier[-2] == "\""
  end

  def valid_numeric_literal?(identifier)
    # lol kludge
    identifier.to_i.to_s == identifier
  end

  def valid_variable_identifier?(identifier)
    # must begin with alphanumeric
    str.match?(VALID_IDENTIFIER_REGEX)
  end

  def resolve(identifier)
    # string literal
    return unless identifier[0] == "\""

    # TODO: handle unterminated strings
    identifier[1..-2]
  end
end

input1 = <<INPUT1
  INCREMENT yourmom by 10

  # this is a comment
  DECREMENT foo by 20
  PRINT foo
  SET foo to 42
  PRINT "Hello world"
  PRINT yourmom
  INCREMENT foo by yourmom
INPUT1

input0 = <<INPUT0
  SET foo to 42
  SET bar to 666
  PRINT foo
  # all done
  INCREMENT foo by 100
  print foo
  decrement foo by 1
  print foo
  increment bar by foo
  print foo
INPUT0

DSL.new.execute(input0)

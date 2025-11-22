# frozen_string_literal: true

class DSL
  TOKENIZE_REGEX = /"[^"]*"|\S+/ # handles quoted strings
  VALID_IDENTIFIER_REGEX = /\A[a-zA-Z]/

  def initialize
    @vars = Hash.new(0)
  end

  def execute(s)
    s.each_line do |line|
      tokens = tokenize_line(line.strip)
      next if skip?(tokens) # comment or blank?

      tokens.delete_if { |x| %w[by to].include?(x.downcase) }

      # puts("tokens: #{tokens} vars:#{@vars} tokens[1]:#{tokens[1]} tokens[3]:#{tokens[3]}")
      roperand = token_to_value(tokens[2])
      loperand = token_to_value(tokens[1])
      result = case tokens[0].downcase
               when "increment"
                 loperand + roperand
               when "decrement"
                 loperand - roperand
               when "set"
                 roperand
               when "print"
                 print(loperand)
               when "println"
                 puts(loperand)
               else
                 raise "Command not recognized: #{tokens[0]}"
               end
      # puts("loperand: #{loperand}  roperand: #{roperand} result: #{result}")
      @vars[tokens[1]] = result if result
    end
  end

  # private
  def get_or_create_variable(token)
    @vars[token] || 0
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

  def valid_string_literal?(token)
    # puts("[jbootz] token is #{token}")
    token[0] == "\"" && token[-1] == "\""
  end

  def valid_numeric_literal?(token)
    # lol kludge
    token.to_i.to_s == token
  end

  # def valid_variable_identifier?(identifier)
  #   # must begin with alphanumeric
  #   str.match?(VALID_IDENTIFIER_REGEX)
  # end

  def token_to_value(token)
    return nil if token.nil?
    return token.to_i if valid_numeric_literal?(token)

    return token[1..-2] if valid_string_literal?(token)

    # puts("do we have a var named #{token}?")
    @vars[token] || 0
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
  println "----[ Annual Report ]----"
  SET cats to 1
  SET dogs to 2
  SET cats 100
  increment cats by 100
  print "Cats: "
  println cats

  # comment
  increment dogs by cats
  print "Dogs: "
  println dogs

INPUT0

badinput1 = <<BADINPUT
  go crazy
BADINPUT

badinput2 = <<BADINPUT
BADINPUT

badinput3 = <<BADINPUT
  SET foo 666
BADINPUT

DSL.new.execute(input0)

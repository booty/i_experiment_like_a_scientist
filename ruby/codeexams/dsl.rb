# frozen_string_literal: true

class DSL
  TOKENIZE_REGEX = /"[^"]*"|\S+/ # handles quoted strings
  VALID_IDENTIFIER_REGEX = /\A[a-zA-Z]/

  def initialize
    @vars = Hash.new(0)
  end

  def execute(program, debug: false)
    program.each_line do |line|
      tokens = tokenize_line(line.strip)
      next if skip?(tokens) # comment or blank

      tokens.delete_if { |x| %w[by to].include?(x.downcase) } # delete optional words

      execute_tokens(tokens, debug)
    end
  end

  def execute_tokens(tokens, debug)
    debugprint("tokens: #{tokens} vars:#{@vars} tokens[1]:#{tokens[1]} tokens[3]:#{tokens[3]}", debug)
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
    debugprint("loperand: #{loperand}  roperand: #{roperand} result: #{result}", debug)
    @vars[tokens[1]] = result if result
  end

  private

  def debugprint(msg, debug)
    return unless debug

    puts("[#{msg}]")
  end

  def get_or_create_variable(token)
    @vars[token] || 0
  end

  def skip?(line)
    true if line.length == 0 or line[0][0] == "#"
  end

  def tokenize_line(line)
    line.scan(TOKENIZE_REGEX)
  end

  def valid_string_literal?(token)
    token[0] == "\"" && token[-1] == "\""
  end

  def valid_numeric_literal?(token)
    (token.to_i.to_s == token) or (token.to_f.to_s == token) # lol kludge
  end

  def token_to_value(token)
    return nil if token.nil?
    return token.to_f if valid_numeric_literal?(token)
    return token[1..-2] if valid_string_literal?(token)

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

float = <<FLOAT
  set myfloat 43.3
  println myfloat
  increment myfloat by 0.1
  println myfloat
FLOAT

DSL.new.execute(float, debug: true)

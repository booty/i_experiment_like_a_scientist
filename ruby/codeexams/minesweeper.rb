# frozen_string_literal: true

# Minesweeper
#
# Kata originated here: acm.uva.es/p/v101/10189.html
#
# Difficulty: Easy
# Problem Description
#
# Have you ever played Minesweeper? It’s a cute little game which comes
# within a certain Operating System whose name we can’t really remember.
# Well, the goal of the game is to find all the mines within an MxN field.
# To help you, the game shows a number in a square which tells you how
# many mines there are adjacent to that square. For instance, take the
# following 4x4 field with 2 mines (which are represented by an *
# character):
#
# *...
# ....
# .*..
# ....
#
# The same field including the hint numbers described above would look like this:
#
# *100
# 2210
# 1*10
# 1110
#
# You should write a program that takes input as follows:
#
# The input will consist of an arbitrary number of fields. The first
# line of each field contains two integers n and m (0 < n,m <= 100)
# which stands for the number of lines and columns of the field
# respectively. The next n lines contains exactly m characters and
# represent the field. Each safe square is represented by an “.” character
# (without the quotes) and each mine square is represented by an “*”
# character (also without the quotes). The first field line where
# n = m = 0 represents the end of input and should not be processed.
#
# Your program should produce output as follows:
#
# For each field, you must print the following message in a line alone:
#
# Field #x:
#
# Where x stands for the number of the field (starting from 1). The next n lines should contain the field with the “.” characters replaced by the number of adjacent mines to that square. There must be an empty line between field outputs.
#
# Suggested Test Cases
#
# This is the acceptance test input:
#
# 4 4
# *...
# ....
# .*..
# ....
# 3 5
# **...
# .....
# .*...
# 0 0
#
# and output:
#
# Field #1:
# *100
# 2210
# 1*10
# 1110
#
# Field #2:
# **100
# 33200
# 1*100

TESTINPUT = <<~TESTINPUT
  4 4
  *...
  ....
  .*..
  ....
  3 5
  **...
  .....
  .*...
  0 0
TESTINPUT

TESTINPUT_MINI = <<~TESTINPUT_MINI
  4 4
  *...
  ....
  .*..
  ....
  0 0
TESTINPUT_MINI

def game(width, height, lines)
  y_max = height - 1
  x_max = width - 1

  (0..y_max).each do |y|
    (0..x_max).each do |x|
      next if lines[y][x] == "*"

      count = 0
      (-1..1).each do |y_offset|
        new_y = y + y_offset
        next unless new_y.between?(0, y_max)

        (-1..1).each do |x_offset|
          new_x = x + x_offset

          next unless new_x.between?(0, x_max)
          next if [new_y, new_x] == [y, x]

          content = lines[new_y][new_x]
          count += 1 if content == "*"
        end
      end
      lines[y][x] = count.to_s
    end
  end
  puts lines
end

def games(input)
  lines = input.lines
  field = 0
  while lines.any?
    line = lines.shift

    y, x = line.split(" ").map.each(&:to_i)

    break if [x, y] == [0, 0]

    field += 1
    puts("\nField ##{field}")
    game(x, y, lines.shift(y))

  end
end

games(TESTINPUT)

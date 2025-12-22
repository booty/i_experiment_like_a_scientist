# frozen_string_literal: true

# Problem Description
#
# Given a letter, print a diamond starting with ‘A’ with the supplied letter at the widest point.
#
# For example: diamond(‘C’) prints
#
#   A
#  B B
# C   C
#  B B
#   A
#
# For example: diamond(‘D’) prints
#
#    A
#   B B
#  C   C
# D     D
#  C   C
#   B B
#    A

def row(c, max_distance)
  current_distance = c.ord - "A".ord
  left_indent = max_distance - current_distance
  print " " * left_indent
  print c

  if c == "A"
    puts
    return
  end
  middle_indent = ((max_distance - left_indent) * 2) - 1
  print " " * middle_indent
  puts c
end

def diamond(char)
  max_distance = char.ord - "A".ord

  ("A"..char).each do |c|
    row(c, max_distance)
  end
  ("A"..char).reverse_each do |c|
    next if c == char

    row(c, max_distance)
  end
end

("A".."E").each do |c|
  diamond(c)
end

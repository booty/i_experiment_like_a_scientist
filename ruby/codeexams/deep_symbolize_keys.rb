# frozen_string_literal: true

# Deep Symbolize Keys
#
# Write a method that deeply converts all hash keys to symbols.
#
# •	Must handle:
#   •	Hash
#   •	Array
#   •	Mixed nesting
# •	Follow-ups:
#   •	Make it non-destructive
#   •	Handle key collisions deterministically
#
# deep_symbolize({ "a" => { "b" => [ { "c" => 1 } ] } })

def deep_symbolize(obj)
  # case obj.class
  # when Array
  #   raise "Not implemented"
  # when Hash
  # end

  # obj.each do |k, v|
  obj.keys.each do |k|
    next if k.is_a?(Symbol)

    raise "Unknown key type: #{k.class}" unless k.is_a?(String)

    obj[k.to_sym] = obj[k]
    obj.delete(k)
  end
  obj
end

inputs = [
  { cat: 1, dog: 2 },
  { "a" => 1, "b" => 2 },
  { :a => 1, "a" => 2, :b => 42, "c" => 3 }
]

inputs.each do |x|
  puts "input: #{x}"
  puts "output: #{deep_symbolize(x)}"
end

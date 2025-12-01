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

def deep_symbolize(obj_old)
  # Nothing to do :-)
  return obj_old unless obj_old.is_a?(Hash) || obj_old.is_a?(Array)

  obj = obj_old.dup

  if obj.is_a?(Array)
    obj.each_index do |i|
      obj[i] = deep_symbolize(obj[i])
    end
    return obj
  end

  obj.keys.each do |k|
    if !k.is_a?(Symbol) && k.respond_to?(:to_sym)
      v = obj[k]
      new_k = k.to_sym
      obj[new_k] = v
      obj.delete(k)
      k = new_k
    end

    return obj_old unless obj_old.is_a?(Hash) || obj_old.is_a?(Array)

    obj[k] = deep_symbolize(obj[k])
  end
  obj
end

inputs = [
  { cat: 1, dog: 2 }.freeze,
  { "a" => 1, "b" => 2 }.freeze,
  { :a => 1, "a" => 2, :b => 42, "c" => 3 }.freeze,
  { "a" => { "b" => [{ "c" => 1 }].freeze } }.freeze,
  [1, 2, 3].freeze,
  [[1, 2, 3], 4].freeze,
  [[1, 2, 3, { "a" => 123 }.freeze].freeze, 4].freeze,
  { "a" => [1, 2, 3] }.freeze
]

inputs.each do |x|
  puts "input: #{x}"
  puts "output: #{deep_symbolize(x)}\n\n"
end

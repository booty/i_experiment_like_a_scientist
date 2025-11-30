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
  if obj.is_a?(Hash)
    obj.keys.each do |k|
      unless k.is_a?(Symbol)
        # convert the key
        v = obj[k]
        new_k = k.to_sym
        obj[new_k] = v
        obj.delete(k)
        k = new_k
      end

      v = obj[k]

      # puts "  #{v.class} #{v.class === Hash}"
      case v
      when Array, Hash
        # puts "  will deep_symbolize #{v}"
        obj[k] = deep_symbolize(v)
      end
    end
    return obj
  end

  return obj unless obj.is_a?(Array)

  obj.each_index do |i|
    obj[i] = deep_symbolize(obj[i])
  end
  obj
end

inputs = [
  { cat: 1, dog: 2 },
  { "a" => 1, "b" => 2 },
  { :a => 1, "a" => 2, :b => 42, "c" => 3 },
  { "a" => { "b" => [{ "c" => 1 }] } },
  [1, 2, 3],
  [[1, 2, 3], 4],
  [[1, 2, 3, { "a" => 123 }], 4],
  { "a" => [1, 2, 3] }
]

inputs.each do |x|
  puts "input: #{x}"
  puts "output: #{deep_symbolize(x)}"
end

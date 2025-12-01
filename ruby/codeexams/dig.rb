# frozen_string_literal: true

# 1.3. Implement Hash#dig
#
# Re-implement Hash#dig without using dig.
# 	•	Must support:
# 	•	Arbitrary depth
# 	•	Arrays inside hashes
# 	•	Follow-up:
# 	•	Implement a fast iterative version vs recursive

class Hash
  def dig(*keys)
    next_h = self
    keys.each_with_index do |k, i|
      next_h = next_h[k]
      puts("key: #{k} next_h:#{next_h}")
      return nil if next_h.nil?
      return next_h if i == keys.length - 1

      raise TypeError, "#{next_h.class} does not have #dig method" unless next_h.respond_to?(:dig)
    end
    nil
  end
end

h = { foo: { bar: { baz: 1 } } }
puts h.dig(:foo, :bar, :baz)     #=> 1
puts h.dig(:foo, :zot, :xyz)     #=> nil

g = { foo: [10, 11, 12] }
puts g.dig(:foo, 1) #=> 11
puts g.dig(:foo, 1, 0) #=> TypeError: Integer does not have #dig method
puts g.dig(:foo, :bar) #=> TypeError: no implicit conversion of Symbol into Integer

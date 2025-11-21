# frozen_string_literal: true

class LRUCache
  def initialize(capacity:)
    @store = {}
    @capacity = capacity
  end

  def set(key, value)
    @store.delete(key) # TODO: ???

    @store[key] = value

    @store.shift if @store.length > @capacity
  end

  def get(key)
    existing = @store.delete(key)

    return nil unless existing

    @store[key] = existing
  end

  def to_s
    @store.to_s
  end

  def inspect
    @store.to_s
  end
end

cache = LRUCache.new(capacity: 3)
cache.set(:a, 1)
cache.set(:b, 2)
cache.get(:a) # => 1 (and now :a is most recent)
puts(cache)
cache.set(:c, 3)
cache.set(:d, 4) # :b should be evicted
puts(cache)
puts(cache.get(:b))

def fibonacci_iterative(n)
  if n <= 0
    return []
  elsif n == 1
    return [0]
  end

  sequence = [0, 1]
  while sequence.length < n
    next_value = sequence[-1] + sequence[-2]
    sequence << next_value
  end

  return sequence
end

def fibonacci_recursive(n)
  return [0] if n == 0
  return [0, 1] if n == 1

  sequence = fibonacci_recursive(n - 1)
  sequence << sequence[-1] + (sequence[-2] || 0)
  sequence
end

# Example usage:
puts "First 10 Fibonacci numbers (iterative): #{fibonacci_iterative(10)}"
puts "First 10 Fibonacci numbers (recursive): #{fibonacci_recursive(10)}"

# frozen_string_literal: true

deepthought = Ractor.new do
  puts "ractor 1 initialized"
  sleep 1
  puts "ractor 1 thinking"
  sleep 1
  puts "ractor 1 finishing"
  42
end

puts "Well, we've created a ractor. Let's wait a moment and then see how it's doing..."
sleep 3
puts "OK, done sleeping!"
answer = deepthought.join

puts "The answer is #{answer}"

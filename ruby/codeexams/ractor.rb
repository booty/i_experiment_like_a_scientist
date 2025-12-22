# frozen_string_literal: true


deepthought = Ractor.new do
  puts "ractor 1 initialized"
  sleep 1
  puts "ractor 1 thinking"
  sleep 1
  puts "ractor 1 finishing"
  42
end

marvin = Ractor.new do
  sleep 0.5
  puts "i'm so depressed"
  sleep 1
  puts "still depressed"
  sleep 1
  puts "oh god :("
  return nil
end

answer = deepthought.take

puts "The answer is #{answer}"

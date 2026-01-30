data = %w[foo bar]
data2 = %w[baz qux]
r = Ractor.new do
  puts "I'm a ractor!"
  data_in_ractor = Ractor.receive
  puts "In ractor: #{data_in_ractor.object_id}, #{data_in_ractor[0].object_id}"
  data_in_ractor2 = Ractor.receive
  puts "In ractor: #{data_in_ractor2.object_id}, #{data_in_ractor2[0].object_id}"
end
r.send(data, move: true)
r.send(data2, move: true)
r.join
# r.join
# puts "Outside: moved? #{data.is_a?(Ractor::MovedObject)}"
# puts "Outside: #{data.inspect}"

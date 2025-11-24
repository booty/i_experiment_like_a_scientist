# frozen_string_literal: true

class RateLimiter
  def initialize(limit:, time_seconds:)
    raise ArgumentError, "Limit must be positive" unless limit.positive?
    raise ArgumentError, "Time window must be positive" unless time_seconds.positive?

    @limit = limit
    @time_seconds = time_seconds.to_f
    @history = Hash.new { |hash, key| hash[key] = [] }
  end

  def allow?(user:)
    trim
    @history[user].push(Time.now.to_f)
    return true if @history[user].length <= @limit

    @history[user] = @history[user][-@limit..]
    false
  end

  private

  def trim
    cutoff = Time.now.to_f - @time_seconds
    @history.each do |user, user_history|
      user_history.delete_if { |x| x < cutoff }
    end
  end
end

rl = RateLimiter.new(limit: 5, time_seconds: 1)

1.upto(3) do
  puts "sally: #{rl.allow?(user: 'sally')}"
end
1.upto(10) do
  puts "john: #{rl.allow?(user: 'john')}"
end
sleep 2
1.upto(3) do
  puts "john: #{rl.allow?(user: 'john')}"
end

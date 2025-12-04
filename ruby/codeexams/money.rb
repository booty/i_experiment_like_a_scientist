# frozen_string_literal: true

class Money
  attr_reader :amount, :currency

  include Comparable

  def initialize(amount, currency)
    @amount = amount
    @currency = currency
    freeze
  end

  def +(other)
    raise ArgumentError, "Can't add #{currency} to #{other.currency}" unless currency == other.currency

    Money.new(amount + other.amount, currency)
  end

  def -(other)
    raise ArgumentError, "Can't subtract #{currency} from #{other.currency}" unless currency == other.currency

    Money.new(amount - other.amount, currency)
  end

  def to_s
    "[~~ #{amount} #{currency} ~~]"
  end

  def <=>(other)
    raise ArgumentError, "Can't compare #{currency} and #{other.currency}" unless currency == other.currency

    amount <=> other.amount
  end

  def eql?(other)
    other.is_a?(Money) &&
      amount == other.amount &&
      currency == other.currency
  end

  def hash
    [amount, currency].hash
  end
end

us10 = Money.new(10, :usd)
us5 = Money.new(5, :usd)
yen100 = Money.new(10, :jpy)

result1 = us10 + us5
puts "result1: I now have #{result1}"

result2 = result1 - us5
puts "result2: I now have #{result2}"

my_money = Money.new(100, :usd)
your_money = Money.new(100, :usd)
her_money = Money.new(200, :usd)

puts "Do I have the same amount of money as you? #{my_money == your_money}"
puts "Do I have the same amount of money as her? #{my_money == her_money}"

puts "Sorted from poorest to richest: #{[my_money, her_money, your_money].sort}"

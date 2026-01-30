class Character
  attr_reader :name, :hp

  class CorpseViolation < StandardError; end

  def initialize(name, initial_hp)
    @name = name
    @hp = initial_hp
  end

  def dead?
    @hp.positive?
  end

  def heal(amt)
    raise CorpseViolation, "Can't heal a dead person" unless @hp.positive?

    @hp += amt
  end

  def damage(amt)
    @hp -= amt
    @hp = 0 if @hp.negative?
  end
end

puts "?"

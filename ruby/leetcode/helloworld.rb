
NAMES = %w{Arlen Tessa Marik Liora Brenna Caden Soren Elara Nico Freya Damon Alina Jorah Myla Quinn Desmond Isla Rowan Evren Calla Mateo Nara Corin Zadie Luca Rhea Silas Taryn Eamon Lyric Malin Jasper Elodie Cassian Mira Declan Sia Aric Noa Kellan Odette Riven Priya Emric Thea Idris Kael Nova Renna Elias}

class Organism
  attr_accessor :name, :parents

  def initialize(name: NAMES.sample, parents: [])
    self.name = name
    self.parents = parents
  end

  def greet
    "... (my name is #{name} but I can't speak because I'm an abstract idea) ..."
  end

  def reproduce_with(other)
    unless self.class == other.class
      raise RuntimeError("Whoa, I'm a #{self.class}! I can't reproduce with a #{other.class}!")
    end

    self.class.new(parents: [self, other])
  end
end


class Human < Organism
  def greet
    "[hands you a business card that says '#{name}']"
  end
end

class SlimeMold < Organism
  def greet
    "squish squish I/we are named #{name}"
  end
end

slimes = [SlimeMold.new]
people = [Human.new, Human.new]

child = people[0].reproduce_with(people[1])

puts("Welcome to the world, #{child.name}! They say: \"#{child.greet}\"")


child = people[1].reproduce_with(slimes[0])

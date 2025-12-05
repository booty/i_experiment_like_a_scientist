# frozen_string_literal: true

require "ice_nine"
require "ice_nine/core_ext/object"

# In-Memory Query Engine
# Given an array of hashes, implement:
#
#   where(users, age: 30).order(:name).limit(10)
#
# Follow-ups:
#   - Lazy evaluation
#   - Indexing optimization

srand(12_345)

FIRST_NAMES = {
  N: %w[Sutton Campbell Alexis Sawyer Skyler Stevie Landry Oakley Max Justice Baylor Greer Charlie Morgan Azariah
        Dylan Bellamy Bellamy Greer Blake Song"],
  M: %w[James Robert John Michael David William Richard Joseph Thomas Charles Santos Rashad Sylvester Elijah Luther
        Joseph Alonso Antwan Rob Clifford],
  F: %w[Mary Patricia Jennifer Linda Elizabeth Barbara Susan Jessica Sarah Karen Chantel Abigail Casie Eleanor
        Laureen Senaida Kasey Darline Tayna Bernarda]
}.deep_freeze

LAST_NAMES =
  %w[Raynor Walter Frami Jast Beer Bergstrom Gutmann Rempel Yost Wolf Klein Doyle Kassulke Stanton Weissnat Paucek Wiza
     Lebsack Runolfsson Herman].deep_freeze

DATA =
  Array.new(10_000) do
    gender = %i[M F N].sample
    { first_name: FIRST_NAMES[gender].sample, last_name: LAST_NAMES.sample, age: rand(18..40) }
  end
DATA.deep_freeze

class QueryEngine
  def initialize(array)
    @data = array
  end

  def order(*attributes)
    result = @data
    attributes.each do |attrib|
      result = result.sort_by { |x| x[attrib] }
    end
    QueryEngine.new(result)
  end

  def limit(count)
    @data.first(count)
  end
end

def where(data, query_hash)
  filtered = data

  query_hash.each do |k, v|
    if filtered.any? && !filtered[0].keys.include?(k)
      raise ArgumentError, "Attribute not found in data: \"#{k}\""

    end

    filtered = filtered.select do |item|
      item[k] == v
    end
  end

  QueryEngine.new(filtered)
end

puts where(DATA, age: 30, first_name: "David").order(:first_name, :last_name, :age).limit(15)

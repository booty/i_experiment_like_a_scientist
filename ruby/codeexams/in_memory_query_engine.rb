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
        Dylan Bellamy Bellamy Greer Blake Song],
  M: %w[James Robert John Michael David William Richard Joseph Thomas Charles Santos Rashad Sylvester Elijah Luther
        Joseph Alonso Antwan Rob Clifford],
  F: %w[Mary Patricia Jennifer Linda Elizabeth Barbara Susan Jessica Sarah Karen Chantel Abigail Casie Eleanor
        Laureen Senaida Kasey Darline Tayna Bernarda]
}.deep_freeze

LAST_NAMES =
  %w[Raynor Walter Frami Jast Beer Bergstrom Gutmann Rempel Yost Wolf Klein Doyle Kassulke Stanton Weissnat Paucek Wiza
     Lebsack Runolfsson Herman].deep_freeze

DATA =
  Array.new(20_000) do
    gender = %i[M F N].sample
    { first_name: FIRST_NAMES[gender].sample, last_name: LAST_NAMES.sample, age: rand(18..40) }
  end
DATA.deep_freeze

class QueryEngine
  def initialize(array)
    @data = array
  end

  def order(*attributes)
    indexed = @data.each_with_index # sort and sort_by are not stable so we need to do a little extra work

    sorted = indexed.sort_by do |row, idx|
      attributes.map { |attr| row.fetch(attr) } << idx
    end

    QueryEngine.new(sorted.map(&:first))
  end

  def limit(count)
    @data.first(count)
  end
end

def where(data, query_hash)
  filtered = data

  query_hash.each do |filter_key, filter_value|
    if filtered.any? && !filtered[0].keys.include?(filter_key)
      raise ArgumentError, "Attribute not found in data: \"#{filter_key}\""
    end

    filtered = filtered.select do |item|
      if filter_value.is_a?(Array)
        filter_value.include?(item[filter_key])
      elsif filter_value.is_a?(Range)

        filter_value.cover?(item[filter_key])
      else
        item[filter_key] == filter_value
      end
    end
  end

  QueryEngine.new(filtered)
end

puts where(DATA, age: 30..35, first_name: %w[David Song]).order(:last_name, :age, :first_name).limit(20)

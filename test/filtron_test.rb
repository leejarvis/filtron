require "test_helper"

class FiltronTest < Minitest::Test

  class Search
    attr_reader :conditions

    def initialize(conditions)
      @conditions = conditions
    end

    def result(options = {})
      self
    end
  end

  class User
    extend Filtron

    filter_with :name, :name_eq
    filter_with :country, :country_name_eq do |code|
      {"gb" => "Great Britain"}[code]
    end
    queries :name, :email, with: :s

    def self.search(conditions)
      Search.new(conditions)
    end
  end

  def test_adding_filters
    assert_equal [:name_eq, {}, nil], User.filtron_filters[:name]
  end

  def test_filters_with_blocks
    assert_equal "Great Britain", User.filter(country: "gb").conditions[:country_name_eq]
  end

  def test_adding_queries
    assert_equal({"name_or_email_cont" => "foo"}, User.filter(s: "foo").conditions)
  end

end

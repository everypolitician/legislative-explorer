# frozen_string_literal: true

require 'pry'
require_rel '../sparql'

module Page
  class Country
    def initialize(country:, divisions:, cities:)
      @country = country
      @divisions = divisions
      @cities = cities
    end

    attr_reader :country, :divisions, :cities

    def title
      "EveryPolitician: #{country.name}"
    end
  end
end

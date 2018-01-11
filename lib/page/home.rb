# frozen_string_literal: true

require 'pry'
require_rel '../sparql'

module Page
  class Home
    def initialize(countries:)
      @countries = countries
    end

    attr_reader :countries

    def title
      "EveryPolitician: Political data for #{countries.count} countries"
    end
  end
end

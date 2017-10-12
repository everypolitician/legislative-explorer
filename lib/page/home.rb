# frozen_string_literal: true

require 'pry'
require_rel '../sparql'

module Page
  class Home
    def initialize; end

    def title
      "EveryPolitician: Political data for #{countries.count} countries"
    end

    def countries
      Sparql.new(sparql).results.map { |h| Country.new(h[:item][:value].split('/').last, h[:itemLabel][:value]) }
    end

    private

    Country = Struct.new(:id, :name)

    def sparql
      @sparql ||= <<~EOQ
        SELECT ?item ?itemLabel WHERE {
          ?item wdt:P31 wd:Q160016.
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
        ORDER BY ?itemLabel
      EOQ
    end
  end
end

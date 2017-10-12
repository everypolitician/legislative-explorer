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
      Sparql.new(sparql).results.map { |h| Country.new(h[:item], h[:itemLabel]) }
    end

    private

    Country = Struct.new(:id, :name)

    def sparql
      @sparql ||= <<~EOQ
        SELECT ?item ?itemLabel WHERE {
          ?item p:P31 ?statement .
          ?statement ps:P31 wd:Q160016 .
          FILTER NOT EXISTS { ?statement pq:P582 ?end }
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
        ORDER BY ?itemLabel
      EOQ
    end
  end
end

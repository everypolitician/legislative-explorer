# frozen_string_literal: true

require_relative '../sparql'

module Query
  class CountryList
    def data
      Sparql.new(sparql).results.map { |row| row[:item] }
    end

    private

    def sparql
      @sparql ||= <<~SPARQL
        SELECT ?item ?itemLabel WHERE {
          ?item p:P31 ?statement .
          ?statement ps:P31 wd:Q160016 .
          MINUS { ?statement pq:P582 ?end }      # no longer a country
          MINUS { ?item wdt:P1552 wd:Q47185282 } # not free
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
        ORDER BY ?itemLabel
      SPARQL
    end
  end
end

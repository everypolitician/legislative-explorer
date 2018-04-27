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
          ?item p:P31 ?instanceOfStatement .
          ?instanceOfStatement ps:P31 wd:Q6256 .
          MINUS { ?instanceOfStatement pq:P582 ?end }  # no longer a country

          ?item p:P463 ?memberOfStatement .
          ?memberOfStatement ps:P463 wd:Q1065 .
          MINUS { ?memberOfStatement pq:P582 ?end }    # no longer a member of the UN

          MINUS { ?item wdt:P1552 wd:Q47185282 }       # not free

          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
        ORDER BY ?itemLabel
      SPARQL
    end
  end
end

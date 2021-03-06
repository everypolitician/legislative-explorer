# frozen_string_literal: true

require_relative '../sparql'

DivisionStruct = SelfAwareStruct.new(:me, :population, :office, :head, :legislatures)

module Query
  class CountryDivisions
    def initialize(id:)
      @id = id
    end

    def data
      division_results.map do |row|
        DivisionStruct.new(*row.values_at(:item, :population, :office, :head), legislatures(row[:item]))
      end.uniq
    end

    private

    attr_reader :id

    def sparql
      @sparql ||= <<~SPARQL
        SELECT DISTINCT ?item ?itemLabel ?population ?office ?officeLabel ?head ?headLabel ?legislature ?legislatureLabel WHERE
        {
          ?item wdt:P31/wdt:P279* wd:Q10864048 ; wdt:P17 wd:#{id} .
          FILTER NOT EXISTS { ?item wdt:P576 [] }
          OPTIONAL { ?item wdt:P1082 ?population }
          OPTIONAL { ?item wdt:P6 ?head }
          OPTIONAL { ?item wdt:P1313 ?office }
          OPTIONAL {
            ?item wdt:P194 ?legislature
            MINUS { ?legislature wdt:P576 ?legislatureEnd }
          }
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
        ORDER BY DESC(?population) ?itemLabel
      SPARQL
    end

    def division_results
      @division_results ||= Sparql.new(sparql).results
    end

    def legislatures(place_id)
      division_results.select { |row| row[:item] == place_id }.map { |row| row[:legislature] }.compact.uniq
    end
  end
end

# frozen_string_literal: true

require_relative '../sparql'

DivisionStruct = SelfAwareStruct.new(:me, :population, :office, :head, :legislatures)

module Query
  class CountryDivisions
    def initialize(id:)
      @id = id
    end

    def data
      division_results.map do |r|
        DivisionStruct.new(*r.values_at(:item, :population, :office, :head), legislatures(r[:item]))
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
          OPTIONAL { ?item wdt:P194 ?legislature }
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
        ORDER BY DESC(?population)
      SPARQL
    end

    def division_results
      @res ||= Sparql.new(sparql).results
    end

    def legislatures(place_id)
      division_results.select { |r| r[:item] == place_id }.map { |i| i[:legislature] }.uniq
    end
  end
end

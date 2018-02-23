# frozen_string_literal: true

require_relative '../sparql'

CountryStruct = SelfAwareStruct.new(:me, :population, :executive, :head, :office, :legislatures)

module Query
  class CountryInfo
    def initialize(id:)
      @id = id
    end

    def data
      h = results.first
      CountryStruct.new(*h.values_at(:country, :population, :executive, :head, :office), legislatures)
    end

    private

    attr_reader :id

    def sparql
      @sparql ||= <<~SPARQL
        SELECT ?country ?countryLabel ?population ?executive ?executiveLabel ?legislature ?legislatureLabel ?legislature_applies_to_matches ?head ?headLabel ?office ?officeLabel WHERE
        {
          BIND(wd:#{id} AS ?country)
          OPTIONAL { ?country wdt:P1082 ?population }.
          OPTIONAL {
            ?country wdt:P194 ?legislature
            MINUS { ?legislature wdt:P576 ?legislatureEnd }
            OPTIONAL { ?legislature wdt:P1001 ?legislature_applies_to_jurisdiction }
            BIND((BOUND(?legislature_applies_to_jurisdiction) && ?legislature_applies_to_jurisdiction = ?country) AS ?legislature_applies_to_matches)
          }.
          OPTIONAL { ?country wdt:P208 ?executive }.
          OPTIONAL { ?country wdt:P6 ?head }.
          OPTIONAL { ?country wdt:P1313 ?office }.
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
      SPARQL
    end

    def results
      @results ||= Sparql.new(sparql).results
    end

    LegislatureStruct = SelfAwareStruct.new(:me, :applies_to_matches?)
    def legislatures
      results.map { |i| LegislatureStruct.new(i[:legislature], i[:legislature_applies_to_matches]) if i[:legislature] }.compact.uniq
    end
  end
end

# frozen_string_literal: true

require_rel '../sparql'

module Query
  class CountryInfo
    def initialize(id:)
      @id = id
    end

    def data
      h = Sparql.new(sparql).results.first
      Country.new(
        h[:country].id,
        h[:country].name,
        h[:population],
        h[:executive],
        h[:head],
        h[:office],
        h[:legislature]
      )
    end

    private

    attr_reader :id

    Country = Struct.new(:id, :name, :population, :executive, :head, :office, :legislature)

    def sparql
      @sparql ||= <<~SPARQL
        SELECT ?country ?countryLabel ?population ?executive ?executiveLabel ?legislature ?legislatureLabel ?head ?headLabel ?office ?officeLabel WHERE
        {
          BIND(wd:#{id} AS ?country)
          OPTIONAL { ?country wdt:P1082 ?population }.
          OPTIONAL { ?country wdt:P194 ?legislature }.
          OPTIONAL { ?country wdt:P208 ?executive }.
          OPTIONAL { ?country wdt:P6 ?head }.
          OPTIONAL { ?country wdt:P1313 ?office }.
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
      SPARQL
    end
  end
end

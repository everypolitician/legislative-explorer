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
        h[:country],
        h[:countryLabel],
        h[:population],
        Item.new(h[:executive], h[:executiveLabel]),
        Item.new(h[:head], h[:headLabel]),
        Item.new(h[:office], h[:officeLabel]),
        Item.new(h[:legislature], h[:legislatureLabel]),
      )
    end

    private

    attr_reader :id

    Item = Struct.new(:id, :name)
    Country = Struct.new(:id, :name, :population, :executive, :head, :office, :legislature)

    def sparql
      @sparql ||= <<~EOQ
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
      EOQ
    end
  end
end

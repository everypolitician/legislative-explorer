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
        h[:item],
        h[:itemLabel],
        h[:population],
        Item.new(h[:executive], h[:executiveLabel]),
        Item.new(h[:head], h[:headLabel]),
        Item.new(h[:office], h[:officeLabel]),
        Item.new(h[:legislature], h[:legislatureLabel])
      )
    end

    private

    attr_reader :id

    Item = Struct.new(:id, :name)
    Country = Struct.new(:id, :name, :population, :executive, :head, :office, :legislature)

    def sparql
      @sparql ||= <<~SPARQL
        SELECT ?item ?itemLabel ?population ?executive ?executiveLabel ?legislature ?legislatureLabel ?head ?headLabel ?office ?officeLabel WHERE
        {
          BIND(wd:#{id} AS ?item)
          OPTIONAL { ?item wdt:P1082 ?population }.
          OPTIONAL { ?item wdt:P194 ?legislature }.
          OPTIONAL { ?item wdt:P208 ?executive }.
          OPTIONAL { ?item wdt:P6 ?head }.
          OPTIONAL { ?item wdt:P1313 ?office }.
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
      SPARQL
    end
  end
end

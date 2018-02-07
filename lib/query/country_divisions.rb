# frozen_string_literal: true

require_rel '../sparql'

module Query
  class CountryDivisions
    def initialize(id:)
      @id = id
    end

    def data
      division_results.map do |r|
        Division.new(
          r[:item],
          r[:itemLabel],
          r[:population],
          Item.new(r[:legislature], r[:legislatureLabel]),
          Item.new(r[:office], r[:officeLabel]),
          Item.new(r[:head], r[:headLabel])
        )
      end
    end

    private

    attr_reader :id

    Item = Struct.new(:id, :name)
    Division = Struct.new(:id, :name, :population, :legislature, :office, :head)

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
  end
end

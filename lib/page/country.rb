# frozen_string_literal: true

require 'pry'
require_rel '../sparql'

module Page
  class Country
    def initialize(id:)
      @id = id
    end

    def title
      "EveryPolitician: #{country.name}"
    end

    def country
      h = Sparql.new(sparql).results.first
      Country.new(
        h[:country],
        h[:countryLabel],
        h[:population],
        Item.new(h[:head], h[:headLabel]),
        Item.new(h[:office], h[:officeLabel]),
        Item.new(h[:legislature], h[:legislatureLabel]),
        city_results.map { |r| Item.new(r[:city], r[:cityLabel]) }
      )
    end

    private

    Item = Struct.new(:id, :name)
    Country = Struct.new(:id, :name, :population, :head, :office, :legislature, :cities)

    def sparql
      @sparql ||= <<~EOQ
        SELECT ?country ?countryLabel ?population ?legislature ?legislatureLabel ?head ?headLabel ?office ?officeLabel WHERE
        {
          BIND(wd:#{@id} AS ?country)
          OPTIONAL { ?country wdt:P1082 ?population }.
          OPTIONAL { ?country wdt:P194 ?legislature }.
          OPTIONAL { ?country wdt:P6 ?head }.
          OPTIONAL { ?country wdt:P1313 ?office }.
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
      EOQ
    end

    def cities_sparql
      @csparql ||= <<~EOQ
        SELECT DISTINCT ?city ?cityLabel ?population WHERE
        {
          ?city wdt:P31/wdt:P279* wd:Q515 ; wdt:P17 wd:#{@id} ; wdt:P1082 ?population .
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
        ORDER BY DESC(?population)
        LIMIT 5
      EOQ
    end

    def city_results
      @cres ||= Sparql.new(cities_sparql).results
    end
  end
end

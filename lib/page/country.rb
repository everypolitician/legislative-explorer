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
        division_results.map { |r| Item.new(r[:item], r[:itemLabel]) },
        city_results.map { |r| Item.new(r[:item], r[:itemLabel]) },
      )
    end

    private

    Item = Struct.new(:id, :name)
    Country = Struct.new(:id, :name, :population, :head, :office, :legislature, :divisions, :cities)

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

    def divisions_sparql
      @dsparql ||= <<~EOQ
        SELECT DISTINCT ?item ?itemLabel WHERE
        {
          ?item wdt:P31/wdt:P279* wd:Q10864048 ; wdt:P17 wd:#{@id} .
          OPTIONAL { ?item wdt:P1082 ?population }
          FILTER NOT EXISTS { ?item wdt:P576 [] }
          SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
        }
        ORDER BY DESC(?population)
      EOQ
    end

    def cities_sparql
      @csparql ||= <<~EOQ
        SELECT DISTINCT ?item ?itemLabel WHERE
        {
          ?item wdt:P31/wdt:P279* wd:Q515 ; wdt:P17 wd:#{@id} ; wdt:P1082 ?population .
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
        ORDER BY DESC(?population)
        LIMIT 5
      EOQ
    end

    def division_results
      @dres ||= Sparql.new(divisions_sparql).results
    end

    def city_results
      @cres ||= Sparql.new(cities_sparql).results
    end

  end
end

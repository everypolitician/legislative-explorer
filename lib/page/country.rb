# frozen_string_literal: true

require 'json'
require 'pry'
require 'rest-client'

module Page
  class Country
    def initialize(id:)
      @id = id
    end

    def title
      "EveryPolitician: #{country.name}"
    end

    def country
      h = results.first
      Country.new(
        h[:country][:value].split('/').last,
        h[:countryLabel][:value],
        h[:population][:value],
        Item.new(h[:head][:value].split('/').last, h[:headLabel][:value]),
        Item.new(h[:office][:value].split('/').last, h[:officeLabel][:value]),
        Item.new(h[:legislature][:value].split('/').last, h[:legislatureLabel][:value]),
        city_results.map { |r| Item.new(r[:city][:value].split('/').last, r[:cityLabel][:value]) },
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

    WIKIDATA_SPARQL_URL = 'https://query.wikidata.org/sparql'.freeze

    def wikidata(query)
      result = RestClient.get WIKIDATA_SPARQL_URL, params: { query: query, format: 'json' }
      json = JSON.parse(result, symbolize_names: true)
      json[:results][:bindings]
    rescue RestClient::Exception => e
      abort "Wikidata query #{query.inspect} failed: #{e.message}"
    end

    def results
      wikidata(sparql)
    end

    def city_results
      binding.pry
      wikidata(cities_sparql)
    end
  end
end

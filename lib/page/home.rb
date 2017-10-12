# frozen_string_literal: true

require 'json'
require 'pry'
require 'rest-client'

module Page
  class Home
    def initialize
    end

    def title
      "EveryPolitician: Political data for #{countries.count} countries"
    end

    def countries
      results.map { |h| Country.new(h[:item][:value].split('/').last, h[:itemLabel][:value]) }
    end

    private

    Country = Struct.new(:id, :name)

    def sparql
      @sparql ||= <<~EOQ
        SELECT ?item ?itemLabel WHERE {
          ?item wdt:P31 wd:Q160016.
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
        ORDER BY ?itemLabel
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
  end
end

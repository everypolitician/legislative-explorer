# frozen_string_literal: true

require 'pry'
require_rel '../sparql'

module Query
  class CountryCities
    def initialize(id:)
      @id = id
    end

    def data
      city_results.map { |r| Item.new(r[:item], r[:itemLabel], r[:population]) }
    end

    private

    attr_reader :id

    Item = Struct.new(:id, :name, :population)

    def sparql
      @sparql ||= <<~EOQ
        SELECT DISTINCT ?item ?itemLabel ?population WHERE
        {
          ?item wdt:P31/wdt:P279* wd:Q515 ; wdt:P17 wd:#{id} ; wdt:P1082 ?population .
          FILTER (?population > 250000)
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
        ORDER BY DESC(?population)
      EOQ
    end

    def city_results
      Sparql.new(sparql).results
    end

  end
end

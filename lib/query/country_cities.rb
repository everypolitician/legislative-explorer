# frozen_string_literal: true

require 'pry'
require_rel '../sparql'

module Query
  class CountryCities
    def initialize(id:)
      @id = id
    end

    def data
      city_results.map { |r| Item.new(r[:item], r[:itemLabel]) }
    end

    private

    attr_reader :id

    Item = Struct.new(:id, :name)

    def sparql
      @sparql ||= <<~EOQ
        SELECT DISTINCT ?item ?itemLabel WHERE
        {
          ?item wdt:P31/wdt:P279* wd:Q515 ; wdt:P17 wd:#{id} ; wdt:P1082 ?population .
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
        ORDER BY DESC(?population)
        LIMIT 5
      EOQ
    end

    def city_results
      Sparql.new(sparql).results
    end

  end
end

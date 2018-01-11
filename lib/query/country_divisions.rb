# frozen_string_literal: true

require 'pry'
require_rel '../sparql'

module Query
  class CountryDivisions
    def initialize(id:)
      @id = id
    end

    def data
      division_results.map { |r| Item.new(r[:item], r[:itemLabel], r[:population]) }
    end

    private

    attr_reader :id

    Item = Struct.new(:id, :name, :population)

    def sparql
      @sparql ||= <<~EOQ
        SELECT DISTINCT ?item ?itemLabel ?population WHERE
        {
          ?item wdt:P31/wdt:P279* wd:Q10864048 ; wdt:P17 wd:#{id} .
          OPTIONAL { ?item wdt:P1082 ?population }
          FILTER NOT EXISTS { ?item wdt:P576 [] }
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
        ORDER BY DESC(?population)
      EOQ
    end

    def division_results
      @res ||= Sparql.new(sparql).results
    end
  end
end

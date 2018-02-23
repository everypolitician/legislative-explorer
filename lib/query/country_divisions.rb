# frozen_string_literal: true

require_relative '../sparql'

DivisionStruct = SelfAwareStruct.new(:me, :population, :office, :head, :legislatures)

module Query
  class CountryDivisions
    def initialize(id:)
      @id = id
    end

    def data
      division_results.map do |r|
        DivisionStruct.new(*r.values_at(:item, :population, :office, :head), legislatures[r[:item]])
      end.uniq
    end

    private

    attr_reader :id

    def sparql
      @sparql ||= <<~SPARQL
        SELECT DISTINCT ?item ?itemLabel ?population ?office ?officeLabel ?head ?headLabel ?legislature ?legislatureLabel ?legislature_applies_to_matches WHERE
        {
          ?item wdt:P31/wdt:P279* wd:Q10864048 ; wdt:P17 wd:#{id} .
          FILTER NOT EXISTS { ?item wdt:P576 [] }
          OPTIONAL { ?item wdt:P1082 ?population }
          OPTIONAL { ?item wdt:P6 ?head }
          OPTIONAL { ?item wdt:P1313 ?office }
          OPTIONAL {
            ?item wdt:P194 ?legislature
            MINUS { ?legislature wdt:P576 ?legislatureEnd }
            OPTIONAL { ?legislature wdt:P1001 ?legislature_applies_to_jurisdiction }
            BIND((BOUND(?legislature_applies_to_jurisdiction) && ?legislature_applies_to_jurisdiction = ?item) AS ?legislature_applies_to_matches)
          }
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
        ORDER BY DESC(?population) ?itemLabel
      SPARQL
    end

    def division_results
      @res ||= Sparql.new(sparql).results
    end

    LegislatureStruct = SelfAwareStruct.new(:me, :applies_to_matches?)
    def legislatures
      division_results.group_by { |result| result[:item] }.map do |item, rows|
        legislatures = rows.select { |row| row[:legislature] }.map do |row|
          LegislatureStruct.new(row[:legislature], (row[:legislature_applies_to_matches] == 'true'))
        end.uniq.compact
        [item, legislatures]
      end.to_h
    end
  end
end

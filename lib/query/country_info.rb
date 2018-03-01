# frozen_string_literal: true

require_relative '../sparql'

CountryStruct = SelfAwareStruct.new(:me, :populations, :executives, :heads, :offices, :legislatures)

module Query
  class CountryInfo
    def initialize(id:)
      @id = id
    end

    def data
      h = results.first
      CountryStruct.new(
        h[:country],
        extract_values(results, :population),
        extract_values(results, :executive), # This is not currently used, should it be?
        extract_values(results, :head),
        extract_values(results, :office),
        extract_values(results, :legislature)
      )
    end

    private

    attr_reader :id

    def sparql
      @sparql ||= <<~SPARQL
        SELECT ?country ?countryLabel ?population ?executive ?executiveLabel ?legislature ?legislatureLabel ?head ?headLabel ?office ?officeLabel WHERE
        {
          BIND(wd:#{id} AS ?country)
          OPTIONAL { ?country wdt:P1082 ?population }.
          OPTIONAL {
            ?country wdt:P194 ?legislature
            MINUS { ?legislature wdt:P576 ?legislatureEnd }
          }.
          OPTIONAL { ?country wdt:P208 ?executive }.
          OPTIONAL { ?country wdt:P6 ?head }.
          OPTIONAL { ?country wdt:P1313 ?office }.
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
      SPARQL
    end

    def results
      @results ||= Sparql.new(sparql).results
    end

    def extract_values(rows, field)
      rows.map { |row| row[field] }.uniq.compact
    end
  end
end

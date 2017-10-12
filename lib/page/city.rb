# frozen_string_literal: true

require 'pry'
require_rel '../sparql'

module Page
  class City
    def initialize(id:)
      @id = id
    end

    def title
      "EveryPolitician: #{city.name}"
    end

    def country
      city.country
    end

    def city
      h = Sparql.new(sparql).results.first
      City.new(
        h[:city][:value].split('/').last,
        h[:cityLabel][:value],
        h[:population][:value],
        Item.new(h[:country][:value].split('/').last, h[:countryLabel][:value]),
        Item.new(h[:head][:value].split('/').last, h[:headLabel][:value]),
        Item.new(h[:office][:value].split('/').last, h[:officeLabel][:value]),
        Item.new(h[:legislature][:value].split('/').last, h[:legislatureLabel][:value])
      )
    end

    private

    Item = Struct.new(:id, :name)
    City = Struct.new(:id, :name, :population, :country, :head, :office, :legislature)

    def sparql
      @sparql ||= <<~EOQ
        SELECT ?city ?cityLabel ?country ?countryLabel ?population ?legislature ?legislatureLabel ?head ?headLabel ?office ?officeLabel WHERE
        {
          BIND(wd:#{@id} AS ?city)
          OPTIONAL { ?city wdt:P17 ?country }.
          OPTIONAL { ?city wdt:P1082 ?population }.
          OPTIONAL { ?city wdt:P194 ?legislature }.
          OPTIONAL { ?city wdt:P6 ?head }.
          OPTIONAL { ?city wdt:P1313 ?office }.
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
      EOQ
    end
  end
end

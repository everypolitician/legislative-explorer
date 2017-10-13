# frozen_string_literal: true

require 'pry'
require_rel '../sparql'

module Page
  class Legislature
    def initialize(id:)
      @id = id
    end

    def title
      "EveryPolitician: #{legislature.name}"
    end

    def country
      legislature.country
    end

    def legislature
      h = Sparql.new(sparql).results.first
      Legislature.new(
        h[:legislature],
        h[:legislatureLabel],
        Item.new(h[:type], h[:typeLabel]),
        Item.new(h[:jurisdiction], h[:jurisdictionLabel]),
        Item.new(h[:country], h[:countryLabel]),
        h[:seats],
        chambers,
      )
    end

    def type
      @type ||= Sparql.new(type_sparql).results.find { |h| h[:isaLabel].include? 'cameral legislature' }[:isaLabel]
    end

    def chambers
      @chambers ||= Sparql.new(parts_sparql).results.map { |h| Item.new(h[:part], h[:partLabel]) }
    end

    def unicameral?
      types.include? 'unicameral legislature'
    end

    def bicameral?
      types.include? 'bicameral legislature'
    end

    def chamber?
      types.include?('lower house') || types.include?('upper house')
    end

    private

    Item = Struct.new(:id, :name)
    Legislature = Struct.new(:id, :name, :type, :jurisdiction, :country, :seats, :chambers)

    def types
      @types ||= Sparql.new(type_sparql).results.map { |r| r[:isaLabel] }.to_set
    end

    def type_sparql
      @type_sparql ||= <<~EOQ
        SELECT ?isa ?isaLabel WHERE
        {
          wd:#{@id} wdt:P31 ?isa .
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
      EOQ
    end

    def parts_sparql
      @parts_sparql ||= <<~EOQ
        SELECT ?part ?partLabel WHERE
        {
          wd:#{@id} wdt:P527 ?part .
          ?part wdt:P31/wdt:P279* wd:Q10553309 .
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
      EOQ
    end

    def sparql
      @sparql ||= <<~EOQ
        SELECT ?legislature ?legislatureLabel ?jurisdiction ?jurisdictionLabel ?country ?countryLabel ?seats ?part ?partLabel WHERE
        {
          BIND(wd:#{@id} AS ?legislature)
          OPTIONAL { ?legislature wdt:P1342 ?seats }.
          OPTIONAL { ?legislature wdt:P1001 ?jurisdiction }.
          OPTIONAL { ?legislature wdt:P17 ?country }.
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
      EOQ
    end

  end
end

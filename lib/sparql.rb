# frozen_string_literal: true

require 'json'
require 'rest-client'

class Sparql
  WIKIDATA_SPARQL_URL = 'https://query.wikidata.org/sparql'

  def initialize(query)
    @query = query
  end

  def results
    bindings.map do |row|
      row.map { |field, value| [field, Datum.new(value).to_s] }.to_h
    end
  end

  private

  attr_reader :query

  def result
    @result ||= RestClient.get WIKIDATA_SPARQL_URL, params: { query: query, format: 'json' }
  rescue RestClient::Exception => e
    abort "Wikidata query #{query.inspect} failed: #{e.message}"
  end

  def raw_json
    @json ||= JSON.parse(result, symbolize_names: true)
  end

  def bindings
    raw_json[:results][:bindings]
  end

  # https://www.wikidata.org/wiki/Special:ListDatatypes
  class Datum
    def initialize(hash)
      @datum = hash
    end

    def type
      datum[:type]
    end

    def value
      datum[:value]
    end

    def to_s
      return value.split('/').last if type == 'uri' and value.include?('http://www.wikidata.org/entity/')
      value
    end

    private

    attr_reader :datum
  end
end

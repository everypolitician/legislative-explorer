# frozen_string_literal: true

require 'json'
require 'rest-client'

class Sparql
  WIKIDATA_SPARQL_URL = 'https://query.wikidata.org/sparql'

  def initialize(query)
    @query = query
  end

  def results
    raw_json[:results][:bindings]
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
end

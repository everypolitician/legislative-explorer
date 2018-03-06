# frozen_string_literal: true

require 'json'
require 'rest-client'

class Sparql
  WIKIDATA_SPARQL_URL = 'https://query.wikidata.org/sparql'

  def initialize(query)
    @query = query
  end

  def results
    bindings.map { |row| Row.new(row).to_h }
  end

  private

  LabelledItem = Struct.new(:id, :name)

  attr_reader :query

  def result
    @result ||= RestClient.get WIKIDATA_SPARQL_URL, params: { query: query, format: 'json' }
  rescue RestClient::Exception => error
    abort "Wikidata query #{query.inspect} failed: #{error.message}"
  end

  def raw_json
    @json ||= JSON.parse(result, symbolize_names: true)
  end

  def bindings
    raw_json[:results][:bindings]
  end

  # Rows are returned from the API in the format:
  # {:item=>{:type=>"uri", :value=>"http://www.wikidata.org/entity/Q222"},
  #  :itemLabel=>{:"xml:lang"=>"en", :type=>"literal", :value=>"Albania"}}
  class Row
    def initialize(hash)
      @data = hash
    end

    # combine all foo + fooLabel column pairs into `LabelledItem`s
    def to_h
      cache = flattened.dup
      paired_column_names.map do |field|
        [field, LabelledItem.new(cache.delete(field.to_sym), cache.delete("#{field}Label".to_sym))]
      end.to_h.merge(cache)
    end

    private

    attr_reader :data

    def flattened
      @flattened ||= data.map { |field, value| [field, Datum.new(value).to_s] }.to_h
    end

    def column_names
      flattened.keys.map(&:to_s)
    end

    # all columns for which there's also a 'columnLabel' (usually from
    # the label service)
    def paired_column_names
      column_names.select { |column| column_names.include? "#{column}Label" }.map(&:to_sym)
    end
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

# This is a bit of a nasty hack that's pushing the concept of a Struct
# right to its limit. We might want to look into pushing this up to a
# full-blown class, but for now it's an experiment whilst we see if it
# has sufficient value first.
#
# Usage: treat like a normal Struct, except if one of the args is a
# `LabelledItem` called :me, it has methods for descending into that
# to avoid the ugliness of `country.country.name` etc.
class SelfAwareStruct < Struct
  def id
    me.id
  end

  def name
    me.name
  end
end

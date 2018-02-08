# frozen_string_literal: true

require_rel '../sparql'

module Query
  class Places
    def initialize(id:)
      @id = id
    end

    def data # rubocop:disable Metrics/MethodLength
      results.map do |r|
        Place.new(
          r[:item],
          r[:itemLabel],
          r[:population],
          Item.new(r[:legislature], r[:legislatureLabel]),
          Item.new(r[:office], r[:officeLabel]),
          Item.new(r[:head], r[:headLabel]),
          Item.new(r[:executive], r[:executiveLabel])
        )
      end
    end

    private

    attr_reader :id

    Item = Struct.new(:id, :name)
    Place = Struct.new(:id, :name, :population, :legislature, :office, :head, :executive)

    def sparql
      raise 'SPARQL query missing'
    end

    def results
      @results ||= Sparql.new(sparql).results
    end
  end
end

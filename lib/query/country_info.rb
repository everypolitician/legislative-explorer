# frozen_string_literal: true

require_rel 'places'

module Query
  class CountryInfo < Places
    def data
      super.first
    end

    private

    def sparql
      @sparql ||= <<~SPARQL
        SELECT ?item ?itemLabel ?population ?executive ?executiveLabel ?legislature ?legislatureLabel ?head ?headLabel ?office ?officeLabel WHERE
        {
          BIND(wd:#{id} AS ?item)
          OPTIONAL { ?item wdt:P1082 ?population }.
          OPTIONAL { ?item wdt:P194 ?legislature }.
          OPTIONAL { ?item wdt:P208 ?executive }.
          OPTIONAL { ?item wdt:P6 ?head }.
          OPTIONAL { ?item wdt:P1313 ?office }.
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
      SPARQL
    end
  end
end

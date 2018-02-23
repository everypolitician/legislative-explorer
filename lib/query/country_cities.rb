# frozen_string_literal: true

require_relative 'country_divisions'

module Query
  class CountryCities < CountryDivisions
    def sparql
      @sparql ||= <<~SPARQL
        SELECT DISTINCT ?item ?itemLabel ?population ?office ?officeLabel ?head ?headLabel ?legislature ?legislatureLabel ?legislature_applies_to_matches WHERE
        {
          ?item wdt:P31/wdt:P279* wd:Q515 ; wdt:P17 wd:#{@id} ; wdt:P1082 ?population .
          FILTER (?population > 250000)
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
        ORDER BY DESC(?population)
      SPARQL
    end
  end
end

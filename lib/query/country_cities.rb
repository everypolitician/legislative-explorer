# frozen_string_literal: true

require 'pry'
require_rel '../sparql'

module Query
  class CountryCities < CountryDivisions
    def sparql
      @sparql ||= <<~EOQ
        SELECT DISTINCT ?item ?itemLabel ?population ?office ?officeLabel ?head ?headLabel ?legislature ?legislatureLabel WHERE
        {
          ?item wdt:P31/wdt:P279* wd:Q515 ; wdt:P17 wd:#{@id} ; wdt:P1082 ?population .
          FILTER (?population > 250000)
          OPTIONAL { ?item wdt:P6 ?head }
          OPTIONAL { ?item wdt:P1313 ?office }
          OPTIONAL { ?item wdt:P194 ?legislature }
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
        ORDER BY DESC(?population)
      EOQ
    end
  end
end

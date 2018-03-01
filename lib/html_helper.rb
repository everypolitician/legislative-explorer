# frozen_string_literal: true

module HTMLHelper
  def unescape_uri(text)
    CGI.unescape(text)
  end

  def show_population(populations)
    populations = [populations].flatten.map { |number| number.to_i.commify }.join(' <em>or</em> ')
    "(pop. #{populations.empty? ? '<em>unknown</em>' : populations})"
  end

  def wikidata_links(items)
    [items].flatten.map do |item|
      %(<a href="https://www.wikidata.org/wiki/#{item.id}">#{item.name}</a>)
    end.join(', ')
  end
end

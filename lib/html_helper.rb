# frozen_string_literal: true

module HTMLHelper
  def unescape_uri(text)
    CGI.unescape(text)
  end

  def show_population(populations)
    populations = [populations] unless populations.is_a?(Array)
    populations = populations.map { |number| number.to_i.commify }.join(' <em>or</em> ')
    populations = '<em>unknown</em>' if populations.empty?
    "(pop. #{populations})"
  end
end

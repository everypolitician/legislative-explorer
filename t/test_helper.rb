# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'nokogiri'
require 'pathname'
require 'rack/test'
require 'pry'
require 'everypolitician'

module Minitest
  class Spec
    include Rack::Test::Methods

    def app
      Sinatra::Application
    end
  end
end

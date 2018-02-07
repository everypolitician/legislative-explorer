# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/around'
require 'nokogiri'
require 'pathname'
require 'rack/test'
require 'pry'
require 'everypolitician'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 't/fixtures/vcr'
  c.hook_into :webmock
end

module Minitest
  class Spec
    include Rack::Test::Methods

    def app
      Sinatra::Application
    end
  end
end

# frozen_string_literal: true

require 'test_helper'
require_relative '../../app'

describe 'Basic web requests' do
  around { |test| VCR.use_cassette('Basic web requests', &test) }

  it 'should get the home page successfully' do
    get '/'
    last_response.status.must_equal 200
  end

  it 'should get a country page successfully' do
    get '/country/Q39'
    last_response.status.must_equal 200
  end

  it 'should get a legislature page successfully' do
    get '/legislature/Q382118'
    last_response.status.must_equal 200
  end
end

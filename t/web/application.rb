# frozen_string_literal: true

require 'test_helper'
require_relative '../../app'

describe 'Basic web requests' do
  around { |test| VCR.use_cassette('Basic web requests', record: :new_episodes, &test) }

  let(:response) do
    get url
    last_response
  end

  describe 'home page' do
    let(:url) { '/' }

    it 'gets the home page successfully' do
      response.status.must_equal 200
    end
  end

  describe 'country page' do
    let(:url) { '/country/Q39' }

    it 'gets a country page successfully' do
      response.status.must_equal 200
    end
  end

  describe 'legislature page' do
    let(:url) { '/legislature/Q382118' }

    it 'gets a legislature page successfully' do
      response.status.must_equal 200
    end
  end
end

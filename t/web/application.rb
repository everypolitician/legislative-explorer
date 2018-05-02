# frozen_string_literal: true

require 'test_helper'
require_relative '../../app'

describe 'Basic web requests' do
  around { |test| VCR.use_cassette('Basic web requests', record: :new_episodes, &test) }

  let(:response) do
    get url
    last_response
  end

  subject { Nokogiri::HTML(response.body) }

  describe 'home page' do
    let(:url) { '/' }

    it 'gets the home page successfully' do
      response.status.must_equal 200
    end

    it 'links to the Estonia page' do
      subject.css('a/@href').map(&:text).must_include '/country/Q191'
    end
  end

  describe 'country page' do
    let(:url) { '/country/Q39' }

    it 'gets a country page successfully' do
      response.status.must_equal 200
    end

    it 'knows which country this is' do
      subject.css('h2').text.must_include 'Switzerland'
    end
  end

  describe 'legislature page' do
    let(:url) { '/legislature/Q382118' }

    it 'gets a legislature page successfully' do
      response.status.must_equal 200
    end

    it 'knows which country this is in' do
      subject.css('h2').text.must_include 'Australia'
    end

    it 'links to the Senate' do
      subject.css('a').map(&:text).must_include 'Senate of Australia'
    end
  end
end

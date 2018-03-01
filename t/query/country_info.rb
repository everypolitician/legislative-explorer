# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/query/country_info'

describe Query::CountryInfo do
  describe 'Estonia (Q191)' do
    around { |test| VCR.use_cassette('CountryInfo Q191', &test) }

    subject { Query::CountryInfo.new(id: 'Q191').data }

    it 'should know its name' do
      subject.name.must_equal 'Estonia'
    end

    it 'should know its population' do
      subject.populations.first.must_equal '1315635'
    end

    it 'should know its head of government' do
      subject.heads.first.name.must_equal 'Jüri Ratas'
    end

    it 'should know its head of government office' do
      subject.offices.first.name.must_equal 'Prime Minister of Estonia'
    end

    it 'should know its legislature' do
      subject.legislatures.first.name.must_equal 'Riigikogu'
    end
  end

  describe 'Germany (Q183)' do
    around { |test| VCR.use_cassette('CountryInfo Q183', &test) }

    subject { Query::CountryInfo.new(id: 'Q183').data }

    it 'should have two legislatures' do
      subject.legislatures.count.must_equal 2
    end
  end

  describe 'Nepal (Q837)' do
    around { |test| VCR.use_cassette('CountryInfo Q837', &test) }

    subject { Query::CountryInfo.new(id: 'Q837').data }

    it 'should not show an abolished legislature' do
      subject.legislatures.map(&:id).wont_include 'Q16057514'
    end
  end

  describe 'San Marino (Q238)' do
    around { |test| VCR.use_cassette('CountryInfo Q238', &test) }

    subject { Query::CountryInfo.new(id: 'Q238').data }

    it 'should have two heads of government' do
      subject.heads.count.must_equal 2
    end
  end
end

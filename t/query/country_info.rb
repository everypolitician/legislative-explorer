# frozen_string_literal: true

require 'test_helper'
require_rel '../../lib/query/country_info'

describe Query::CountryInfo do
  describe 'Estonia (Q191)' do
    around { |test| VCR.use_cassette('CountryInfo Q191', &test) }

    subject { Query::CountryInfo.new(id: 'Q191').data }

    it 'should know its name' do
      subject.name.must_equal 'Estonia'
    end

    it 'should know its population' do
      subject.population.must_equal '1315635'
    end

    it 'should know its head of government' do
      subject.head.name.must_equal 'Jüri Ratas'
    end

    it 'should know its head of government office' do
      subject.office.name.must_equal 'Prime Minister of Estonia'
    end

    it 'should know its legislature' do
      subject.legislature.name.must_equal 'Riigikogu'
    end
  end
end

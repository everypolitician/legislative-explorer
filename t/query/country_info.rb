# frozen_string_literal: true

require 'test_helper'
require_rel '../../lib/query/country_info'

describe Query::CountryInfo do
  describe 'Estonia (Q191)' do
    before { VCR.insert_cassette('CountryInfo Q191') }
    after { VCR.eject_cassette }

    subject { Query::CountryInfo.new(id: 'Q191') }

    it 'should know its name' do
      subject.data.name.must_equal 'Estonia'
    end

    it 'should know its population' do
      subject.data.population.must_equal '1315635'
    end

    it 'should know its head of government' do
      subject.data.head.name.must_equal 'Jüri Ratas'
    end

    it 'should know its head of government office' do
      subject.data.office.name.must_equal 'Prime Minister of Estonia'
    end

    it 'should know its legislature' do
      subject.data.legislature.name.must_equal 'Riigikogu'
    end
  end
end

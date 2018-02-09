# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/query/country_cities'

describe Query::CountryCities do
  describe 'Estonia (Q191)' do
    around { |test| VCR.use_cassette('CountryCities Q191', &test) }

    let(:estonia_cities) { Query::CountryCities.new(id: 'Q191') }

    describe 'Tallinn' do
      subject { estonia_cities.data.find { |c| c.id == 'Q1770' } }

      it 'should know its name' do
        subject.name.must_equal 'Tallinn'
      end

      it 'should know its population' do
        subject.population.must_equal '446055'
      end

      it 'should know its head of government' do
        subject.head.name.must_equal 'Taavi Aas'
      end

      it 'should know its head of government office' do
        subject.office.name.must_equal 'mayor of Tallinn'
      end
    end
  end
end

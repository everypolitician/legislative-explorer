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

  describe 'United States of America (Q30)' do
    around { |test| VCR.use_cassette('CountryCities Q30', &test) }

    let(:cities) { Query::CountryCities.new(id: 'Q30').data }

    describe 'Los Angeles (Q65)' do
      subject { cities.find { |c| c.id == 'Q65' } }

      it 'should only be listed once' do
        cities.select { |c| c.id == 'Q65' }.count.must_equal 1
      end

      it 'should not list an abolished legislature' do
        subject.legislatures.map(&:id).wont_include 'Q6682043'
      end
    end
  end

  describe 'Israel (Q801)' do
    around { |test| VCR.use_cassette('CountryCities Q801', &test) }

    let(:cities) { Query::CountryCities.new(id: 'Q801').data }

    describe 'Jerusalem (Q1218)' do
      subject { cities.find { |c| c.id == 'Q1218' } }

      it 'should have one legislature' do
        subject.legislatures.count.must_equal 1
      end
    end
  end
end

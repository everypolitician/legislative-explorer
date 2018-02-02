# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/page/country'

def country_page(qid)
  country = Query::CountryInfo.new(id: qid).data
  divisions = Query::CountryDivisions.new(id: qid).data
  cities = Query::CountryCities.new(id: qid).data
  Page::Country.new(country: country, divisions: divisions, cities: cities)
end

describe 'Estonia Page' do
  subject { country_page('Q191') }

  describe 'Country data' do
    it 'should know its name' do
      subject.country.name.must_equal 'Estonia'
    end

    it 'should know its population' do
      subject.country.population.must_equal '1315635'
    end

    it 'should know its head of government' do
      subject.country.head.name.must_equal 'Jüri Ratas'
    end

    it 'should know its head of government office' do
      subject.country.office.name.must_equal 'Prime Minister of Estonia'
    end

    it 'should know its legislature' do
      subject.country.legislature.name.must_equal 'Riigikogu'
    end
  end

  describe 'Divisions data' do
    let(:harju) { subject.divisions.find { |c| c.id == 'Q180200' } }

    it 'should know some divisions' do
      harju.name.must_equal 'Harju County'
    end

    it 'should know info about cities' do
      harju.head.name.must_equal 'Ülle Rajasalu'
    end
  end

  describe 'City data' do
    let(:tallinn) { subject.cities.find { |c| c.id == 'Q1770' } }

    it 'should know some cities' do
      tallinn.name.must_equal 'Tallinn'
    end

    it 'should know info about cities' do
      tallinn.office.name.downcase.must_equal 'mayor of tallinn'
    end
  end

  describe 'title' do
    it 'should give the country name in the title' do
      subject.title.must_include 'Estonia'
    end
  end
end

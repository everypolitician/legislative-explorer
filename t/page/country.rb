# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/page/country'

describe 'Homepage' do
  subject { Page::Country.new(id: 'Q191') }

  describe 'data' do
    it 'should know its name' do
      subject.country.name.must_equal 'Estonia'
    end

    it 'should know its population' do
      subject.country.population.must_equal '1313271'
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

    it 'should know some cities' do
      subject.country.cities.map(&:name).must_include 'Tallinn'
    end
  end

  describe 'title' do
    it 'should give the name in the title' do
      subject.title.must_include 'Estonia'
    end
  end
end

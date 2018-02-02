# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/page/city'

describe 'Homepage' do
  subject { Page::City.new(id: 'Q60') }

  describe 'data' do
    it 'should know its name' do
      subject.city.name.must_equal 'New York City'
    end

    it 'should know its country' do
      subject.city.country.name.must_equal 'United States of America'
    end

    it 'should know its population' do
      subject.city.population.must_equal '8537673'
    end

    it 'should know its head of government' do
      subject.city.head.name.must_equal 'Bill de Blasio'
    end

    it 'should know its head of government office' do
      subject.city.office.name.must_equal 'Mayor of New York City'
    end

    it 'should know its legislature' do
      subject.city.legislature.name.must_equal 'New York City Council'
    end
  end

  describe 'title' do
    it 'should give the name in the title' do
      subject.title.must_include 'New York City'
    end
  end
end

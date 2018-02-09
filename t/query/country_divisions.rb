# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/query/country_info'

describe Query::CountryDivisions do
  describe 'Estonia (Q191)' do
    around { |test| VCR.use_cassette('CountryDivisions Q191', &test) }

    let(:estonia_divisions) { Query::CountryDivisions.new(id: 'Q191') }

    describe 'Harju County' do
      subject { estonia_divisions.data.find { |c| c.id == 'Q180200' } }

      it 'should know its name' do
        subject.name.must_equal 'Harju County'
      end

      it 'should know its population' do
        subject.population.must_equal '575601'
      end

      it 'should know its head of government' do
        subject.head.name.must_equal 'Ülle Rajasalu'
      end
    end
  end

  describe 'Switzerland (Q39)' do
    around { |test| VCR.use_cassette('CountryDivisions Q39', &test) }

    let(:divisions) { Query::CountryDivisions.new(id: 'Q39').data }

    describe 'Canton of Glarus (Q11922)' do
      subject { divisions.find { |c| c.id == 'Q11922' } }

      it 'should have two legislatures' do
        subject.legislatures.count.must_equal 2
      end
    end
  end
end

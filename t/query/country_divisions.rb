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
        subject.populations.first.must_equal '575601'
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

      it 'should only be listed once' do
        divisions.select { |c| c.id == 'Q11922' }.count.must_equal 1
      end

      it 'should have two legislatures' do
        subject.legislatures.count.must_equal 2
      end
    end
  end

  describe 'Australia (Q408)' do
    around { |test| VCR.use_cassette('CountryDivisions Q408', &test) }

    let(:divisions) { Query::CountryDivisions.new(id: 'Q408').data }

    describe 'Norfolk Island (Q31057)' do
      subject { divisions.find { |c| c.id == 'Q31057' } }

      it 'should not list an abolished legislature' do
        subject.legislatures.map(&:id).wont_include 'Q7051064'
      end
    end
  end

  describe 'Latvia (Q211)' do
    around { |test| VCR.use_cassette('CountryDivisions Q211', &test) }

    let(:divisions) { Query::CountryDivisions.new(id: 'Q211').data }

    describe 'Aglona Municipality (Q2045300)' do
      subject { divisions.find { |c| c.id == 'Q2045300' } }

      it 'should only be listed once' do
        divisions.select { |c| c.id == 'Q2045300' }.count.must_equal 1
      end

      it 'should have two population numbers listed' do
        subject.populations.count.must_equal 2
      end
    end
  end
end

describe Query::CountryDivisions do
  describe 'Mozambique (Q1029)' do
    around { |test| VCR.use_cassette('CountryDivisions Q1029', &test) }

    let(:names) { Query::CountryDivisions.new(id: 'Q1029').data.map(&:name) }

    it 'should list places of equal population alphabetically' do
      cabo = names.find_index { |name| name == 'Cabo Delgado Province' }
      gaza = names.find_index { |name| name == 'Gaza Province' }
      cabo.must_be :<, gaza
    end
  end
end

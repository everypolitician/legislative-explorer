# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/html_helper'

describe HTMLHelper do
  subject do
    Class.new { include HTMLHelper }
  end

  describe 'show_population' do
    it 'should show a single population from a String' do
      subject.new.show_population('123').must_equal '(pop. 123)'
    end

    it 'should show a single population from an Array' do
      subject.new.show_population(['123']).must_equal '(pop. 123)'
    end

    it 'should show multiple population' do
      subject.new.show_population(%w[123 456]).must_equal '(pop. 123 <em>or</em> 456)'
    end

    it 'should show an unknown population' do
      subject.new.show_population([]).must_equal '(pop. <em>unknown</em>)'
    end
  end

  describe 'wikidata_links' do
    let(:item) { Struct.new(:id, :name) }
    let(:douglas_adams) { item.new('Q42', 'Douglas Adams') }
    let(:ursula_le_guin) { item.new('Q181659', 'Ursula K. Le Guin') }

    it 'should show a single link' do
      subject.new.wikidata_links(douglas_adams).must_equal '<a href="https://www.wikidata.org/wiki/Q42">Douglas Adams</a>'
    end

    it 'should show multiple links' do
      text = subject.new.wikidata_links([ursula_le_guin, douglas_adams])
      text.must_equal '<a href="https://www.wikidata.org/wiki/Q181659">Ursula K. Le Guin</a>, ' \
                      '<a href="https://www.wikidata.org/wiki/Q42">Douglas Adams</a>'
    end
  end
end

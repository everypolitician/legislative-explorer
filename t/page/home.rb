# frozen_string_literal: true

require 'test_helper'

require_rel '../../lib'

describe 'Homepage' do
  subject { Page::Home.new(countries: Query::CountryList.new.data) }

  describe 'countries' do
    it 'should include free countries' do
      subject.countries.map(&:name).must_include 'Colombia'
    end

    it 'should not include non-free countries' do
      subject.countries.map(&:name).wont_include 'China'
    end
  end

  describe 'title' do
    it 'should give the country count in the title' do
      subject.title.must_include '145 countries'
    end
  end
end

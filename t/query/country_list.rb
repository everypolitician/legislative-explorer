# frozen_string_literal: true

require 'test_helper'
require_rel '../../lib/query/country_list'

describe Query::CountryList do
  subject do
    VCR.use_cassette('CountryList') { Query::CountryList.new.data }
  end

  it 'should get 145 countries' do
    subject.count.must_equal 145
  end

  it 'should include free countries' do
    subject.map(&:name).must_include 'Colombia'
  end

  it 'should not include non-free countries' do
    subject.map(&:name).wont_include 'China'
  end
end

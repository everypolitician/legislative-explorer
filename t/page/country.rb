# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/page/country'

describe 'Estonia Page' do
  let(:country_estonia) do
    country_estonia = Minitest::Mock.new
    country_estonia.expect :name, 'Estonia'
  end
  subject { Page::Country.new(country: country_estonia, divisions: Minitest::Mock.new, cities: Minitest::Mock.new) }

  describe 'title' do
    it 'should give the country name in the title' do
      subject.title.must_include 'Estonia'
    end
  end
end

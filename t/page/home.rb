# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/page/home'

describe 'Homepage' do
  describe 'title' do
    subject { Page::Home.new(countries: Array.new(145)) }

    it 'should give the country count in the title' do
      subject.title.must_include '145 countries'
    end
  end
end

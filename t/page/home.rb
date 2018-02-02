# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/page/home'

describe 'Homepage' do
  subject { Page::Home.new }

  describe 'countries' do
    it 'should include Colombia' do
      subject.countries.map(&:name).must_include 'Colombia'
    end

    it 'should not include Kosovo' do
      subject.countries.map(&:name).wont_include 'Kosovo'
    end
  end

  describe 'title' do
    it 'should give the country count in the title' do
      subject.title.must_include '193 countries'
    end
  end
end

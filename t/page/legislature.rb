# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/page/legislature'

describe 'Unicameral' do
  let(:page) { Page::Legislature.new(id: 'Q217799') }
  subject { page.legislature }

  describe 'data' do
    it 'should know its name' do
      subject.name.must_equal 'Riigikogu'
    end

    it 'has the correct type' do
      page.type.must_equal 'unicameral legislature'
    end

    it 'should be unicameral' do
      page.unicameral?.must_equal true
    end

    it 'should not be bicameral' do
      page.bicameral?.must_equal false
    end

    it 'should know its seat count' do
      subject.seats.must_equal '101'
    end

    it 'should be in Estonia' do
      subject.country.name.must_equal 'Estonia'
    end

    it 'should have jurisdiction of Estonia' do
      subject.jurisdiction.name.must_equal 'Estonia'
    end

    it 'should not have chambers' do
      subject.chambers.count.must_equal 0
    end
  end
end

describe 'Bicameral' do
  let(:page) { Page::Legislature.new(id: 'Q11010') }
  subject { page.legislature }

  describe 'data' do
    it 'should know its name' do
      subject.name.must_equal 'Parliament of the United Kingdom'
    end

    it 'has the correct type' do
      page.type.must_equal 'bicameral legislature'
    end

    it 'should not be unicameral' do
      page.unicameral?.must_equal false
    end

    it 'should be bicameral' do
      page.bicameral?.must_equal true
    end

    it 'should not have seats' do
      subject.seats.must_be_nil
    end

    it 'should be in the UK' do
      subject.country.name.must_equal 'United Kingdom'
    end

    it 'should have jurisdiction of the UK' do
      subject.jurisdiction.name.must_equal 'United Kingdom'
    end

    it 'should have chambers' do
      subject.chambers.count.must_equal 2
      subject.chambers.map(&:id).must_equal %w[Q11005 Q11007]
    end
  end
end

describe 'Lower' do
  let(:page) { Page::Legislature.new(id: 'Q11005') }
  subject { page.legislature }

  describe 'data' do
    it 'should know its name' do
      subject.name.must_equal 'House of Commons'
    end

    it 'is a chamber' do
      page.chamber?.must_equal true
    end

    it 'should have seats' do
      subject.seats.must_equal '650'
    end

    it 'should be in the UK' do
      subject.country.name.must_equal 'United Kingdom'
    end

    it 'should have jurisdiction of the UK' do
      subject.jurisdiction.name.must_equal 'United Kingdom'
    end
  end
end

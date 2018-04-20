# frozen_string_literal: true

require 'cgi'
require 'dotenv'
require 'open-uri'
require 'require_all'
require 'sass'
require 'sinatra'

require_all 'lib'

class Integer
  def commify
    to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end
end

Dotenv.load

set :erb, trim: '-'

get '/' do
  countries = Query::CountryList.new.data
  @page = Page::Home.new(countries: countries)
  erb :homepage
end

get '/country/:qid' do |qid|
  country = Query::CountryInfo.new(id: qid).data
  divisions = Query::CountryDivisions.new(id: qid).data
  cities = Query::CountryCities.new(id: qid).data

  @page = Page::Country.new(country: country, divisions: divisions, cities: cities)
  erb :country
end

get '/legislature/:qid' do |qid|
  @page = Page::Legislature.new(id: qid)
  erb :legislature
end

get '/*.css' do |filename|
  scss :"sass/#{filename}"
end

get '/404.html' do
  erb :fourohfour
end

not_found do
  status 404
  erb :fourohfour
end

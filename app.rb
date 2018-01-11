# frozen_string_literal: true
require 'cgi'
require 'dotenv'
require 'open-uri'
require 'require_all'
require 'sass'
require 'sinatra'

require_relative './lib/html_helper'
require_rel './lib/page'
require_rel './lib/query'

Dotenv.load
helpers HTMLHelper

set :erb, trim: '-'

get '/' do
  countries = Query::CountryList.new.data
  @page = Page::Home.new(countries: countries)
  erb :homepage
end

get '/country/:qid' do |qid|
  @page = Page::Country.new(id: qid)
  erb :country
end

get '/city/:qid' do |qid|
  @page = Page::City.new(id: qid)
  erb :city
end

get '/division/:qid' do |qid|
  @page = Page::City.new(id: qid)
  erb :city
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

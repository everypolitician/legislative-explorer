# frozen_string_literal: true
require 'cgi'
require 'dotenv'
require 'open-uri'
require 'require_all'
require 'sass'
require 'sinatra'

require_relative './lib/html_helper'
require_rel './lib/page'

Dotenv.load
helpers HTMLHelper

set :erb, trim: '-'

get '/' do
  @page = Page::Home.new
  erb :homepage
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

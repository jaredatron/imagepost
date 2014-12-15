require 'rubygems'
require 'bundler'
Bundler.setup

require File.expand_path('../app', __FILE__)

run App.new

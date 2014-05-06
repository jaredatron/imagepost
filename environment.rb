ENV['RACK_ENV'] ||= 'development'

Bundler.require :default, ENV['RACK_ENV']

$:.unshift File.expand_path('..', __FILE__)

DataMapper.setup(:default, 'postgres://localhost/imagepost')


require 'image_post'
require 'image_post/post'
require 'image_post/image'
require 'image_post/storage'



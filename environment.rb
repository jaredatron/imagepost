ENV['RACK_ENV'] ||= 'development'

require 'json'
Bundler.require :default, ENV['RACK_ENV']

$:.unshift File.expand_path('..', __FILE__)

DataMapper.setup(:default, 'postgres://localhost/imagepost')


Dotenv.load if defined? Dotenv

require 'image_post'
require 'image_post/style'
require 'image_post/post'
require 'image_post/image'
require 'image_post/storage'



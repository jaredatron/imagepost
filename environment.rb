ENV['RACK_ENV'] ||= 'development'

require 'json'
Bundler.require :default, ENV['RACK_ENV']

$:.unshift File.expand_path('..', __FILE__)

Dotenv.load if defined? Dotenv

DataMapper.setup(:default, ENV['DATABASE_URL'])


require 'image_post'
require 'image_post/twitter_client'
require 'image_post/user'
require 'image_post/style'
require 'image_post/post'
require 'image_post/image'
require 'image_post/storage'


DataMapper.finalize

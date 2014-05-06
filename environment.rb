ENV['RACK_ENV'] ||= 'development'

Bundler.require ENV['RACK_ENV']

$:.unshift File.expand_path('../models', __FILE__)

DataMapper.setup(:default, 'postgres://localhost/imagepost')
require 'post'


case ENV['RACK_ENV']
when 'development'


end


storage = Fog::Storage.new({
  :local_root => '~/fog',
  :provider   => 'Local'
})

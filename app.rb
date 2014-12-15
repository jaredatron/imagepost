ENV['RACK_ENV'] ||= 'development'
ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', __FILE__)
require 'bundler' unless defined? Bundler
Bundler.require(:default, ENV['RACK_ENV'])
require File.expand_path('../jsx', __FILE__)
require 'rack/ssl'
Dotenv.load! if defined?(Dotenv)

class App < Sinatra::Base

  helpers Sprockets::Helpers
  register Sinatra::AssetPipeline

  use Rack::SSL if production?

  set :assets_precompile, %w(
    application.js
    application.css
    tests.js
    tests.css
    *.gif
    *.png
    *.jpg
    *.svg
    *.eot
    *.ttf
    *.woff
    *.swf
  )
  set :assets_protocol, :https
  set :assets_css_compressor, :sass
  set :assets_prefix, %w(assets vendor/assets)
  set :assets_js_compressor, (development? ? nil : :uglifier)

  Sprockets::Helpers.configure do |config|
    config.debug = true if development?
  end

  sprockets.append_path File.join(Gem::Specification.find_by_name('react-source').full_gem_path, 'build')
  sprockets.register_engine '.jsx', React::JSX::Template

  unless production?
    sprockets.cache = Sprockets::Cache::FileStore.new(Pathname(root).join('tmp/assets'))
  end

  get '/_tests' do
    haml :tests
  end

  get '/*' do
    haml :application
  end

end

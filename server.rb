Bundler.require

require 'sinatra/asset_pipeline'

class Server < Sinatra::Base

  set :assets_prefix, %w(assets vendor/assets)
  set :assets_css_compressor, :sass
  register Sinatra::AssetPipeline

  helpers do
    include Sprockets::Helpers
  end

  get '/' do
    haml :index
  end

  post '/' do
    # create an image post
  end

  get '/:id' do
    # display an image post
  end

end

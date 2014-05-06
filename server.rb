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
    ImagePost.create(
      text:  params[:text],
      image: params[:image],
      style: params[:style],
    )
  end

  get '/:id' do
    # display an image post
  end

end

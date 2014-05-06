require File.expand_path('../environment', __FILE__)
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
    post = Post.new
    post.text  = params['text'].to_s
    post.style = params['style'].to_i
    post.image = params['image'].to_s
    binding.pry
    redirect to "/#{post.uuid}"
  end

  get '/:uuid' do
    @post = Post.first(uuid: params[:uuid])
    haml :show
  end

end

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
    post = ImagePost::Post.new
    image = ImagePost::Image.create(post.uuid, params['image'])
    post.text      = params['text'].to_s
    post.style     = params['style'].to_i
    post.image_url = image.url
    post.save!

    redirect to "/#{post.uuid}"
  end

  get '/:uuid' do
    @post = ImagePost::Post.first(uuid: params[:uuid])
    haml :show
  end

end

require File.expand_path('../environment', __FILE__)
require 'sinatra/asset_pipeline'
require "sinatra/content_for"

class Server < Sinatra::Base

  set :assets_prefix, %w(assets vendor/assets)
  set :assets_css_compressor, :sass
  register Sinatra::AssetPipeline

  helpers Sinatra::ContentFor
  helpers Sprockets::Helpers

  helpers do

    def url_to path
      return path unless URI.parse(path).relative?
      url = URI.parse(request.url)
      url.path = path
      url.to_s
    end

    def image_url name
      url_to image_path(name)
    end

    def style_for_post post
      {
        "color"            => post.style.font_color,
        "font-size"        => post.style.font_size,
        "font-family"      => post.style.font_family,
        "background-color" => post.style.background_color,
        "background-image" => post.style.background_image ? "url(#{image_url post.style.background_image})" : nil,
      }.map{|k,v| "#{k}: #{v}; "}.join
    end

  end

  get '/' do
    haml :index
  end

  post '/' do
    post  = ImagePost::Post.new
    image = ImagePost::Image.create(post.uuid, params['image'])

    post.text        = params['text'].to_s
    post.style_index = params['style_index'].to_i
    post.image_url   = url_to image.url
    post.save!

    redirect to "/#{post.uuid}"
  end

  get '/:uuid.?:format?' do
    @post = ImagePost::Post.first(uuid: params[:uuid])
    case params[:format]
    when 'png'
      redirect @post.image_url
    else
      haml :show
    end
  end

end

require File.expand_path('../environment', __FILE__)
require 'sinatra/asset_pipeline'
require "sinatra/content_for"

class Server < Sinatra::Base

  set :assets_precompile, %w(application.js application.css *.png *.jpg *.svg *.eot *.ttf *.woff)
  set :assets_prefix, %w(assets vendor/assets)
  set :assets_css_compressor, :sass

  register Sinatra::AssetPipeline

  enable :sessions

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

    def oauth_callback_url
      to('/oauth/callback')
    end

    def twitter_api_key
      ENV['IMAGE_POST_TWITTER_API_KEY']
    end

    def twitter_api_secret
      ENV['IMAGE_POST_TWITTER_API_SECRET']
    end

    def oauth_consumer
      @oauth_consumer ||= OAuth::Consumer.new twitter_api_key, twitter_api_secret, :site => 'https://api.twitter.com'
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


  get '/oauth/request_token' do
    request_token = oauth_consumer.get_request_token :oauth_callback => oauth_callback_url
    session[:twitter_oauth_request_token] = request_token.token
    session[:twitter_oauth_request_token_secret] = request_token.secret

    puts "request: #{session[:twitter_oauth_request_token]}, #{session[:twitter_oauth_request_token_secret]}"

    redirect request_token.authorize_url
  end

  get '/oauth/callback' do
    puts "CALLBACK: request: #{session[:twitter_oauth_request_token]}, #{session[:twitter_oauth_request_token_secret]}"

    request_token = OAuth::RequestToken.new oauth_consumer, session[:twitter_oauth_request_token], session[:twitter_oauth_request_token_secret]
    access_token = request_token.get_access_token :oauth_verifier => params[:oauth_verifier]

    client = Twitter::REST::Client.new do |config|
      config.consumer_key       = twitter_api_key
      config.consumer_secret    = twitter_api_secret
      config.oauth_token        = access_token.token
      config.oauth_token_secret = access_token.secret
    end

    "[#{client.user.screen_name}] access_token: #{access_token.token}, secret: #{access_token.secret}"
  end

end

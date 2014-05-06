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

    def sign_in! user
      session[:user_id] = user.id
    end

    def sign_out!
      session.clear
      @current_user = nil
    end

    def signed_in?
      !session[:user_id].nil?
    end

    def current_user
      @current_user ||= ImagePost::User.get(session[:user_id])
    end

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

    def oauth_consumer
      @oauth_consumer ||= OAuth::Consumer.new ImagePost.twitter_api_key, ImagePost.twitter_api_secret, :site => 'https://api.twitter.com'
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
    return redirect to('/') if signed_in?

    request_token = oauth_consumer.get_request_token :oauth_callback => oauth_callback_url
    session[:twitter_oauth_request_token] = request_token.token
    session[:twitter_oauth_request_token_secret] = request_token.secret

    puts "request: #{session[:twitter_oauth_request_token]}, #{session[:twitter_oauth_request_token_secret]}"

    redirect request_token.authorize_url
  end

  get '/oauth/callback' do
    return redirect to('/') if signed_in?

    puts "CALLBACK: request: #{session[:twitter_oauth_request_token]}, #{session[:twitter_oauth_request_token_secret]}"

    request_token = OAuth::RequestToken.new oauth_consumer, session[:twitter_oauth_request_token], session[:twitter_oauth_request_token_secret]
    access_token = request_token.get_access_token :oauth_verifier => params[:oauth_verifier]

    user = ImagePost::User.find_or_create_by_twitter_oauth_token!(access_token)
    sign_in! user
    redirect to('/')
  end

end

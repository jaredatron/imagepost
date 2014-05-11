require File.expand_path('../environment', __FILE__)
require 'sinatra/asset_pipeline'
require "sinatra/content_for"

class Server < Sinatra::Base

  set :assets_precompile, %w(application.js application.css *.png *.jpg *.svg *.eot *.ttf *.woff)
  set :assets_prefix, %w(assets vendor/assets)
  set :assets_css_compressor, :sass

  register Sinatra::AssetPipeline

  enable :sessions
  set :session_secret, 'a3dda2c072b411b2d96bcf44981f7a29901e42b4'

  helpers Sinatra::ContentFor
  helpers Sprockets::Helpers

  use OmniAuth::Builder do
    provider :twitter, ImagePost.twitter_api_key, ImagePost.twitter_api_secret
  end

  helpers do

    def sign_in! user
      session[:user_id] = user.id
    end

    def sign_out!
      session.clear
      @current_user = nil
    end

    def signed_in?
      !session[:user_id].nil? && !current_user.nil?
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
    if signed_in?
      redirect to('/post')
    else
      haml :homepage
    end
  end

  get '/sign_in' do
    redirect to("/auth/twitter")
  end

  get '/sign_out' do
    sign_out!
    redirect to('/')
  end

  get '/auth/twitter/callback' do
    if env['omniauth.auth'].valid?
      access_token = env['omniauth.auth']["extra"]["access_token"]
      user = ImagePost::User.find_or_create_by_twitter_oauth_token!(access_token)
      sign_in! user
      redirect to('/')
    else
      "Login failed"
    end
  end

  get '/auth/failure' do
    "Login failed: #{params[:message]}"
  end

  get '/post' do
    abort(redirect('/')) unless signed_in?

    haml :'post/new'
  end

  post '/post' do
    abort(redirect('/')) unless signed_in?

    post  = ImagePost::Post.new
    image = ImagePost::Image.create(post.uuid, params['image'])

    post.text        = params['text'].to_s
    post.style_index = params['style_index'].to_i
    post.image_url   = url_to image.url
    post.save!

    redirect to "/post/#{post.uuid}"
  end

  get '/post/:uuid.?:format?' do
    @post = ImagePost::Post.first(uuid: params[:uuid])
    case params[:format]
    when 'png'
      redirect @post.image_url
    when 'html', nil
      haml :'post/show'
    else
      404
    end
  end

  post '/post/:uuid/tweet' do
    abort(redirect('/')) unless signed_in?

    post  = ImagePost::Post.first(uuid: params[:uuid])
    image = ImagePost::Image.get(params[:uuid]).body

    # image = HTTParty.get(post.image_url)
    # image = params['image'].sub('data:image/png;base64,', '')
    # image = Base64.decode64(image)
    path = Tempfile.new(Time.now.to_i.to_s).path + '.png'
    File.open(path, 'wb'){|f| f.write image }
    file = File.open(path)

    status = "#{post.title} #{to("/post/#{post.uuid}")}"

    tweet = current_user.twitter_client.update_with_media(status, file)

    redirect tweet.uri.to_s
  end

end

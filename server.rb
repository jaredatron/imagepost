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

  use Rack::Session::Cookie,
    :key => 'rack.session',
    # :domain => 'foo.com',
    :path => '/',
    :expire_after => 2592000, # In seconds
    :secret => 'a3dda2c072b411b2d96bcf44981f7a29901e42b4'

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
      # !session[:user_id].nil?
      true
    end

    def current_user
      # @current_user ||= ImagePost::User.get(session[:user_id])
      @current_user ||= ImagePost::User.first
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

  get '/sign_in' do
    redirect to("/auth/twitter")
  end

  get '/auth/twitter/callback' do
    binding.pry
    # env['omniauth.auth'] ? session[:admin] = true : halt(401,'Not Authorized')
    "You are now logged in"
  end

  get '/auth/failure' do
    params[:message]
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

  require 'open-uri'

  post '/' do

    image = params['image'].sub('data:image/png;base64,', '')
    image = Base64.decode64(image)
    path = Tempfile.new(Time.now.to_i.to_s).path + '.png'
    File.open(path, 'wb'){|f| f.write image }
    file = File.open(path)

    tweet = current_user.twitter_client.update_with_media('test', upload)



    # post  = ImagePost::Post.new
    # image = ImagePost::Image.create(post.uuid, params['image'])

    # post.text        = params['text'].to_s
    # post.style_index = params['style_index'].to_i
    # post.image_url   = url_to image.url
    # post.save!


    # if current_user
    #   # uri = URI.parse(post.image_url)
    #   # media = uri.open
    #   # media.instance_eval("def original_filename; '#{File.basename(uri.path)}'; end")

    #   # current_user.twitter_client.update_with_media(post.title, image.to_string_io)

    #   image_data = params['image'].sub('data:image/png;base64,', '')
    #   image_data = Base64.decode64(image_data)
    #   image_data = StringIO.new(image_data)

    #   media = UploadIO.new(image_data,  "image/png", "image.png")

    #   binding.pry

    #   current_user.twitter_client.update_with_media(post.title, media)
    # end

    redirect to "/#{post.uuid}"
  end

  get '/:uuid.?:format?' do
    @post = ImagePost::Post.first(uuid: params[:uuid])
    case params[:format]
    when 'png'
      redirect @post.image_url
    when 'html', nil
      haml :show
    else
      404
    end
  end

end

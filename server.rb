require File.expand_path('../environment', __FILE__)
require 'sinatra/asset_pipeline'
require "sinatra/content_for"

class Server < Sinatra::Base

  autoload :Helpers, 'server/helpers'

  set :assets_precompile, %w(application.js application.css *.png *.jpg *.svg *.eot *.ttf *.woff)
  set :assets_prefix, %w(assets vendor/assets)
  set :assets_css_compressor, :sass

  register Sinatra::AssetPipeline

  enable :sessions
  set :session_secret, 'a3dda2c072b411b2d96bcf44981f7a29901e42b4'

  helpers Sinatra::ContentFor
  helpers Sprockets::Helpers
  helpers Server::Helpers

  use OmniAuth::Builder do
    provider :twitter, ImagePost.twitter_api_key, ImagePost.twitter_api_secret
  end

  get '/' do
    haml :homepage
  end

  get '/auth/twitter/callback' do
    if env['omniauth.auth'].valid?
      access_token = env['omniauth.auth']["extra"]["access_token"]
      user = ImagePost::User.find_or_create_by_twitter_oauth_token!(access_token)
      sign_in! user
      redirect to('/')
    else
      "Login failed\n\n#{env['omniauth.auth'].inspect}"
    end
  end

  post '/' do
    post = ImagePost::Post.create!(
      text:        params['text'],
      style_index: params['style_index'].to_i,
      image:       params['image'],
    )
    case params['autopost']
    when 't'
      abort redirect('/auth/twitter') unless connected_to_twitter?
      current_user.post_to_twitter!(post)
    # when 'f'
    end
    redirect to post_path(post)
  end

  get '/:uuid.?:format?' do
    @post = ImagePost::Post.get(params[:uuid])
    case params[:format]
    when 'png'
      redirect post_image_url(@post)
    when 'html', nil
      haml :show
    else
      404
    end
  end

  # get '/auth/failure' do
  #   "Login failed: #{params[:message]}"
  # end

  # get '/post' do
  #   abort(redirect('/')) unless signed_in?

  #   haml :'post/new'
  # end

  # post '/post' do
  #   abort(redirect('/')) unless signed_in?

  #   post  = ImagePost::Post.new
  #   image = ImagePost::Image.create(post.uuid, params['image'])

  #   post.text        = params['text'].to_s
  #   post.style_index = params['style_index'].to_i
  #   post.image_url   = url_to image.url
  #   post.save!

  #   redirect to "/post/#{post.uuid}"
  # end



  # post '/post/:uuid/tweet' do
  #   abort(redirect('/')) unless signed_in?

  #   post  = ImagePost::Post.first(uuid: params[:uuid])
  #   image = ImagePost::Image.get(params[:uuid]).body

  #   # image = HTTParty.get(post.image_url)
  #   # image = params['image'].sub('data:image/png;base64,', '')
  #   # image = Base64.decode64(image)
  #   path = Tempfile.new(Time.now.to_i.to_s).path + '.png'
  #   File.open(path, 'wb'){|f| f.write image }
  #   file = File.open(path)

  #   status = "#{post.title} #{to("/post/#{post.uuid}")}"

  #   tweet = current_user.twitter_client.update_with_media(status, file)

  #   redirect tweet.uri.to_s
  # end

end

module Server::Helpers

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

module ImagePost::TwitterClient

  def self.new oauth_token, oauth_token_secret
    Twitter::REST::Client.new do |config|
      config.consumer_key       = ImagePost.twitter_api_key
      config.consumer_secret    = ImagePost.twitter_api_secret
      config.oauth_token        = oauth_token
      config.oauth_token_secret = oauth_token_secret
    end
  end

end

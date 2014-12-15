class ImagePost::User

  include DataMapper::Resource

  storage_names[:default] = "users"

  property :id,                         Serial
  property :twitter_id,                 Integer,   :key => true
  property :name,                       String
  property :twitter_oauth_token,        String
  property :twitter_oauth_token_secret, String
  property :created_at,                 DateTime

  def self.find_or_create_by_twitter_oauth_token! oauth_token
    client = ImagePost::TwitterClient.new(oauth_token.token, oauth_token.secret)
    user = first_or_create(twitter_id: client.user.id)
    user.update(
      name:                       client.user.name,
      twitter_oauth_token:        oauth_token.token,
      twitter_oauth_token_secret: oauth_token.secret,
    )
    user
  end

  def twitter_client
    @twitter_client ||= ImagePost::TwitterClient.new(twitter_oauth_token, twitter_oauth_token_secret)
  end

end

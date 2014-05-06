module ImagePost

  def self.root
    @root ||= Pathname File.expand_path('..', __FILE__)
  end

  def self.env
    @env ||= (ENV['RACK_ENV'] || 'development').to_sym
  end

  def self.twitter_api_key
    ENV['IMAGE_POST_TWITTER_API_KEY']
  end

  def self.twitter_api_secret
    ENV['IMAGE_POST_TWITTER_API_SECRET']
  end

end

module ImagePost

  def self.root
    @root ||= Pathname File.expand_path('..', __FILE__)
  end

  def self.env
    @env ||= (ENV['RACK_ENV'] || 'development').to_sym
  end

end

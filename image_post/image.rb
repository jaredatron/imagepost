require 'base64'

class ImagePost::Image

  def self.create uuid, data
    base64 = data.sub('data:image/png;base64,', '')
    data = Base64.decode64(base64)
    url = ImagePost::Storage.put("#{uuid}.png", data)
    new url
  end

  def initialize url
    @url = url
  end

  attr_reader :url

end

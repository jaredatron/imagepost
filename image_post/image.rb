require 'base64'

class ImagePost::Image

  def self.create uuid, data
    base64 = data.sub('data:image/png;base64,', '')
    data = Base64.decode64(base64)
    url = ImagePost::Storage.put("#{uuid}.png", data)
    new uuid, url, data
  end

  def initialize uuid, url, data
    @uuid, @url, @data = uuid, url, data
  end

  attr_reader :uuid, :url, :data

  def read
    data
  end

  def original_filename
    "#{uuid}.png"
  end

  def to_string_io
    Data.new("#{uuid}.png", data)
  end

  class Data < StringIO

    def initialize original_filename, content
      @original_filename = original_filename
      super content
    end

    attr_reader :original_filename
  end

end

require 'securerandom'

class ImagePost::Post

  include DataMapper::Resource

  storage_names[:default] = "posts"

  property :id,          Serial
  property :uuid,        String,   required: true, default: ->(*){ SecureRandom.uuid }
  property :text,        String,   required: true
  property :style_index, Integer,  required: true
  property :image_url,   String,   required: true, length: 255
  property :created_at,  DateTime

  def style
    @style ||= ImagePost::Style[style_index] if style_index
  end

  def title
    text.scan(/((?:@|#)\w+)/).flatten.join(' ')
  end

end

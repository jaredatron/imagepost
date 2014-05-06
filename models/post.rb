require 'securerandom'

class Post

  include DataMapper::Resource

  property :id,         Serial
  property :uuid,       String,   required: true, default: ->(*){ SecureRandom.uuid }
  property :text,       String,   required: true
  property :style,      Integer,  required: true
  property :image_url,  String,   required: true
  property :created_at, DateTime

end

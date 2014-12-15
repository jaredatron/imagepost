require 'securerandom'

class ImagePost::Post

  class Record
    include DataMapper::Resource
    storage_names[:default] = "posts"
    property :id,          Serial
    property :uuid,        String,   required: true, default: ->(*){ SecureRandom.uuid }, :key => true
    property :text,        String,   required: true, length: 255
    property :style_index, Integer,  required: true
    property :created_at,  DateTime
  end

  def self.create! attributes
    record = Record.new(
      text:        attributes[:text].to_s,
      style_index: attributes[:style_index].to_i,
    )
    image = ImagePost::Image.create(record.uuid, attributes[:image])
    record.save!
    new record
  end

  NotFound = Class.new(StandardError)

  def self.get uuid
    record = Record.first(uuid: uuid) or raise NotFound, "unable to find post with uuid #{uuid}"
    new record
  end

  def initialize record
    @record = record
  end
  attr_reader :record

  def uuid
    record.uuid
  end

  def text
    record.text
  end

  def style_index
    record.style_index
  end

  def created_at
    record.created_at
  end

  def image
    @image ||= ImagePost::Image.get(uuid)
  end

  def image_url
    image.public_url
  end

  def style
    ImagePost::Style[style_index] if style_index
  end

  def title
    text.scan(/((?:@|#)\w+)/).flatten.join(' ')
  end

end

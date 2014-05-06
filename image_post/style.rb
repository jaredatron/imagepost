class ImagePost::Style

  STYLES = YAML.load_file(ImagePost.root + 'config/styles.yml')

  def self.[] index
    new index, STYLES[index] or raise KeyError, "invalid style index: #{index}"
  end

  def self.all
    STYLES.each_with_index.map{|style, index| new index, style}
  end

  def initialize index, definition
    @index            = index
    @font_size        = definition['font_size']
    @font_family      = definition['font_family']
    @font_color       = definition['font_color']
    @background_color = definition['background_color']
    @background_image = definition['background_image']
  end

  attr_reader \
    :index,
    :font_size,
    :font_family,
    :font_color,
    :background_color,
    :background_image

  def background_image_url
    @background_image ? "/assets/#{@background_image}" : nil
  end

  def to_json options=nil
    {
      "fontSize"           => font_size,
      "fontFamily"         => font_family,
      "fontColor"          => font_color,
      "backgroundColor"    => background_color,
      "backgroundImageUrl" => background_image_url,
    }.to_json(options)
  end

end

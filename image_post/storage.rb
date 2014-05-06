module ImagePost::Storage

  def self.local?
    ImagePost.env != :production
  end

  def self.put path, body
    file = files.create(key: path, body: body, public: true)
    url_to_file file
  end

  def self.url_to_file file
    if local?
      "/storage/#{ImagePost.env}/#{file.key}"
    else
      file.public_url
    end
  end

  def self.files
    @files ||= directory.files
  end

  def self.directory
    @directory ||= connection.directories.get(directory_name) or
      connection.directories.create(key: directory_name, public: true)
  end

  def self.directory_name
    if local?
      ImagePost.env.to_s
    else
      ENV['IMAGE_POST_S3_BUCKET_NAME']
    end
  end

  def self.connection
    @connection ||= if local?
      Fog::Storage.new({
        :local_root => ImagePost.root.join('public/storage'),
        :provider   => 'Local'
      })
    else
      Fog::Storage.new({
        :provider              => 'AWS',
        :aws_access_key_id     => ENV['IMAGE_POST_S3_ACCESS_KEY_ID'],
        :aws_secret_access_key => ENV['IMAGE_POST_S3_SECRET_ACCESS_KEY'],
      })
    end
  end

end

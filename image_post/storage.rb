module ImagePost::Storage

  def self.put path, body
    file = files.create(key: path, body: body)
    File.join(path_prefix, file.key)
  end

  def self.path_prefix
    @path_prefix ||= case ImagePost.env
    when :production
      raise 'NOT IMPLEMENTED YET'
    else
      "/storage/#{ImagePost.env}"
    end
  end

  def self.files
    @fog_storage ||= case ImagePost.env
    when :production
      raise 'NOT IMPLEMENTED YET'
    else
      local_storage = Fog::Storage.new({
        :local_root => ImagePost.root.join('public/storage'),
        :provider   => 'Local'
      })
      local_storage.directories.create(key: ImagePost.env.to_s).files
    end
  end

end

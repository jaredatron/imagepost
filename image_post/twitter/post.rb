require 'net/http/post/multipart'


class ImagePost::Twitter::Post

  # include HTTParty
  # base_uri 'api.twitter.com'

  # https://api.twitter.com/1.1/statuses/update_with_media.json

  # def initialize
  #   File.open(example_image_path) do |image|
  #     @request = Net::HTTP::Post::Multipart.new(uri.path,
  #       'status'  => 'test',
  #       "media[]" => UploadIO.new(image, "image/jpeg", "image.jpg"),
  #     )
  #     @response = Net::HTTP.start(uri.host, uri.port) do |http|
  #       http.request(@request)
  #     end
  #   end
  # end
  # attr_reader :request, :response

  # def example_image_path
  #   ImagePost.root.join('assets/images/orange.jpg').to_s
  # end

  def response
    @response ||= HTTParty.post(uri,
      headers: {
        "Content-Type"  => 'multipart/form-data',
        "Authorization" => oauth_auth_header.to_s,
      },
      query: {
        'status'  => 'test',
        'media[]' => File.open(ImagePost.root.join('assets/images/orange.jpg').to_s)
      }
    )
  end

  def uri
    @uri ||= Addressable::URI.parse('https://api.twitter.com/1.1/statuses/update_with_media.json')
  end

  def params
    @params ||= {}
  end

  def oauth_auth_header
    @oauth_auth_header ||= SimpleOAuth::Header.new(
      'post',
      uri,
      params,
      {
        :consumer_key    => 'OzimyktV585FLxPSAghoWxydM',
        :consumer_secret => 'BKFy74q3bwkpl9ZeVOYUyn6kmYuMtNqXCrNqOwaMq43YS52XRF',
        :token           => '7865122-uOMIX7e5vZNiwTE5lDnitQqix9hfiMaHpQrTAAhgEy',
        :token_secret    => 'idlkwq9stAR2qbkTkktB82hKRgh9xVC0UOWSK9So49yyR',
      }
    )
  end

  #  Content-Type should be set to multipart/form-data
  # param: "media[]"


  # "Authorization" => /oauth_signature="FbthwmgGq02iQw%2FuXGEWaL6V6eM%3D"/



  # POST /1/statuses/update.json?include_entities=true HTTP/1.1
  # Accept: */*
  # Connection: close
  # User-Agent: OAuth gem v0.4.4
  # Content-Type: application/x-www-form-urlencoded
  # Authorization:
  #         OAuth oauth_consumer_key="xvz1evFS4wEEPTGEFPHBog",
  #               oauth_nonce="kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg",
  #               oauth_signature="tnnArxj06cWHq44gCs1OSKk%2FjLY%3D",
  #               oauth_signature_method="HMAC-SHA1",
  #               oauth_timestamp="1318622958",
  #               oauth_token="370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb",
  #               oauth_version="1.0"
  # Content-Length: 76
  # Host: api.twitter.com

  # status=Hello%20Ladies%20%2b%20Gentlemen%2c%20a%20signed%20OAuth%20request%21


end



class MyTwitter < Ohm::Model
  include BaseModel

  attribute :request_token
  attribute :request_secret
  attribute :access_token
  attribute :access_secret
  attribute :connect

  def authorize_url(callback_url)
    consumer = OAuth::Consumer.new(
      APP_CONFIG['twitter_consumer_key'],
      APP_CONFIG['twitter_consumer_secret'],
      :site => "https://api.twitter.com")

    token = consumer.get_request_token(:oauth_callback => callback_url)

    self.request_token = token.token
    self.request_secret = token.secret
    self.save

    "#{token.authorize_url}&oauth_callback=#{callback_url}"
  end

  def auth(oauth_verifier)
    consumer = OAuth::Consumer.new(
      APP_CONFIG['twitter_consumer_key'],
      APP_CONFIG['twitter_consumer_secret'],
      :site => "https://api.twitter.com")

    request_token = OAuth::RequestToken.new(consumer, self.request_token, self.request_secret)
    access_token = request_token.get_access_token(:oauth_verifier => oauth_verifier)

    self.access_token = access_token.token
    self.access_secret = access_token.secret
    self.connect = 'true'
    self.save
  end

end

class MyWeibo < Ohm::Model
  attribute :request_token
  attribute :request_secret
  attribute :oauth_token
  attribute :oauth_secret

  def self.fetch
    all.first || create
  end

  def authorize_url(callback_url)
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    token = oauth.consumer.get_request_token

    self.request_token = token.token
    self.request_secret = token.secret
    self.save

    "#{token.authorize_url}&oauth_callback=#{callback_url}"
  end

  def auth(oauth_verifier)
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_request(self.request_token, request_secret, oauth_verifier)
    access_token = oauth.access_token

    self.oauth_token = access_token.token
    self.oauth_secret = access_token.secret
    self.save
  end
end

require File.join(File.dirname(__FILE__), 'config', 'environment')

my_twitter = MyTwitter.fetch
my_weibo = MyWeibo.fetch

TweetStream.configure do |config|
  config.consumer_key       = APP_CONFIG['twitter_consumer_key']
  config.consumer_secret    = APP_CONFIG['twitter_consumer_secret']
  config.oauth_token        = my_twitter.access_token
  config.oauth_token_secret = my_twitter.access_secret
  config.auth_method        = :oauth
end

client = TweetStream::Client.new

client.on_error do |message|
  puts message
end

client.on_direct_message do |direct_message|
  puts direct_message.text
end

client.on_timeline_status  do |status|
  puts status.text

  oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
  oauth.authorize_from_access(my_weibo.oauth_token, my_weibo.oauth_secret)
  Weibo::Base.new(oauth).update(status.text)
end

client.userstream

class MyApp < Sinatra::Base
  enable :sessions

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    erb :index
  end

  get '/connect' do
=begin
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    request_token = oauth.consumer.get_request_token
    session[:rtoken], session[:rsecret] = request_token.token, request_token.secret
    redirect "#{request_token.authorize_url}&oauth_callback=http://#{request.env["HTTP_HOST"]}/callback"
=end
  end

  get '/callback' do
=begin
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_request(session[:rtoken], session[:rsecret], params[:oauth_verifier])
    session[:rtoken], session[:rsecret] = nil, nil
    session[:atoken], session[:asecret] = oauth.access_token.token, oauth.access_token.secret
    "token: #{session[:atoken]} secret: #{session[:asecret]}"
=end
  end
end

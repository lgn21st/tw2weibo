class MyApp < Sinatra::Base
  enable :sessions

  configure :development do
    register Sinatra::Reloader
  end

  helpers do
    def callback_url(provider)
      "http://#{request.env["HTTP_HOST"]}/auth/#{provider}/callback"
    end
  end

  get '/' do
    erb :index
  end

  get '/connect' do
    if params[:provider] == 'twitter'
      client = MyTwitter.fetch
    else
      client = MyWeibo.fetch
    end

    redirect client.authorize_url(callback_url(params[:provider]))
=begin
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    request_token = oauth.consumer.get_request_token
    session[:rtoken], session[:rsecret] = request_token.token, request_token.secret
    redirect "#{request_token.authorize_url}&oauth_callback=http://#{request.env["HTTP_HOST"]}/callback"
=end
  end

  get '/auth/:provider/callback' do
    if params[:provider] == 'twitter'
      client = MyTwitter.fetch
    else
      client = MyWeibo.fetch
    end

    client.auth params[:oauth_verifier]
    redirect '/'

=begin
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_request(session[:rtoken], session[:rsecret], params[:oauth_verifier])
    session[:rtoken], session[:rsecret] = nil, nil
    session[:atoken], session[:asecret] = oauth.access_token.token, oauth.access_token.secret
    "token: #{session[:atoken]} secret: #{session[:asecret]}"
=end
  end
end

class MyApp < Sinatra::Base
  enable :sessions

  configure :development do
    register Sinatra::Reloader
  end

  configure :production do
    use Rack::Auth::Basic, "Protected Area" do |username, password|
      username == APP_CONFIG['username'] && password == APP_CONFIG['password']
    end
  end

  helpers do
    def callback_url(provider)
      "http://#{request.env["HTTP_HOST"]}/auth/#{provider}/callback"
    end
  end

  get '/' do
    erb :index, :locals => {:my_twitter => MyTwitter.fetch, :my_weibo => MyWeibo.fetch}
  end

  get '/connect' do
    if params[:provider] == 'twitter'
      client = MyTwitter.fetch
    else
      client = MyWeibo.fetch
    end

    redirect client.authorize_url(callback_url(params[:provider]))
  end

  get '/disconnect' do
    if params[:provider] == 'twitter'
      client = MyTwitter.fetch
    else
      client = MyWeibo.fetch
    end

    client.disconnect!
    redirect '/'
  end

  get '/auth/:provider/callback' do
    if params[:provider] == 'twitter'
      client = MyTwitter.fetch
    else
      client = MyWeibo.fetch
    end

    client.auth params[:oauth_verifier]
    redirect '/'
  end
end

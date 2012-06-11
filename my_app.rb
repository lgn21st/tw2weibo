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

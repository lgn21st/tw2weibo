require 'spec_helper'

def mock_client(callback_url="default_url")
  mock(
    :authorize_url => callback_url,
    :auth => true
  )
end

describe MyApp do
  context "/" do
    it "should be ok" do
      get '/'

      last_response.should be_ok
    end
  end

  context "/connect" do
    it "should find MyWeibo instance" do
      MyWeibo.should_receive(:fetch)
      get '/connect', :provider => 'weibo'
    end

    it "should find MyTwitter instance" do
      MyTwitter.should_receive(:fetch)
      get '/connect', :provider => 'twitter'
    end

    it "should be redirect to twitter" do
      provider = 'twitter'
      authorize_url = "http://example.org/auth/#{provider}/callback"
      client = mock_client(authorize_url)
      client.should_receive(:authorize_url).with(authorize_url)
      MyTwitter.should_receive(:fetch).and_return(client)

      get '/connect', :provider => 'twitter'

      last_response.should be_redirect
    end

    it "should be redirect to twitter authorize_url with callback" do
      authorize_url = "http://example.org/fack_twitter_authorize_url"
      client = mock_client(authorize_url)
      MyTwitter.should_receive(:fetch).and_return(client)

      get '/connect', :provider => 'twitter'
      follow_redirect!

      last_request.url.should == authorize_url
    end
  end

  context "/auth/:provider/callback" do
    it "shouls fetch Twitter client" do
      MyTwitter.should_receive(:fetch).and_return(mock_client)
      get '/auth/twitter/callback', :oauth_verifier => 'fake_oauth_verifier'

      last_response.should be_redirect
    end
  end
end

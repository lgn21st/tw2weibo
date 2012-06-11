require 'spec_helper'

def mock_token
  mock(
    :token => 'mock_token',
    :secret => 'mock_secret'
  )
end

describe MyTwitter do

  context ".fetch" do
    it "should create record if doesn't exists" do
      MyTwitter.fetch.should_not be_nil
    end

    it "should find the first record" do
      my_twitter = MyTwitter.fetch
      MyTwitter.fetch.should == my_twitter
    end
  end

  context "#authorize_url" do
    before do
      OAuth::Consumer.stub_chain(:new, :get_request_token).and_return(mock_token)
    end

    it "should save request_token and request_secret" do
      MyTwitter.fetch.authorize_url('callbak_url')

      my_twitter = MyTwitter.fetch
      my_twitter.request_token.should == 'mock_token'
      my_twitter.request_secret.should == 'mock_secret'
    end

    it "should return authorize_url with oauth_callback" do
      MyTwitter.fetch.authorize_url('fake_callback_url').should == "mock_authorize_url&oauth_callback=fake_callback_url"
    end
  end

  context "#auth" do
    before do
      my_twitter = MyTwitter.fetch
      my_twitter.request_token = 'fake_token'
      my_twitter.request_secret = 'fake_secret'
      my_twitter.save
    end

    it "should save oauth_token and oauth_secret" do
      oauth = mock
      OAuth::RequestToken.stub_chain(:new, :get_access_token).and_return(mock_token)

      MyTwitter.fetch.auth('fake_oauth_verifier')

      my_twitter = MyTwitter.fetch
      my_twitter.access_token.should == 'mock_token'
      my_twitter.access_secret.should == 'mock_secret'
    end
  end
end

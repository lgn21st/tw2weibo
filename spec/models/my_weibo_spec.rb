require 'spec_helper'

def mock_token
  mock(
    :token => 'mock_token',
    :secret => 'mock_secret',
    :authorize_url => 'mock_authorize_url',
    :oauth => true
  )
end

describe MyWeibo do

  context ".fetch" do
    it "should create if no exist" do
      MyWeibo.fetch.should_not be_nil
    end

    it "should find the first record" do
      my_weibo = MyWeibo.fetch
      MyWeibo.fetch.should == my_weibo
    end

    context "#authorize_url" do
      before do
        Weibo::OAuth.stub_chain(:new, :consumer, :get_request_token).and_return(mock_token)
      end

      it "should save request_token and request_secret" do
        MyWeibo.fetch.authorize_url('callbak_url')

        my_weibo = MyWeibo.fetch
        my_weibo.request_token.should_not be_nil
        my_weibo.request_token.should == 'mock_token'
        my_weibo.request_secret.should_not be_nil
        my_weibo.request_secret.should == 'mock_secret'
      end

      it "should return authorize_url with oauth_callback" do
        MyWeibo.fetch.authorize_url('fake_callback_url').should == "mock_authorize_url&oauth_callback=fake_callback_url"
      end
    end

    context "#auth" do
      before do
        my_weibo = MyWeibo.fetch
        my_weibo.request_token = 'fake_token'
        my_weibo.request_secret = 'fake_secret'
        my_weibo.save
      end

      it "should save oauth_token and oauth_secret" do
        oauth = mock
        Weibo::OAuth.stub!(:new).and_return(oauth)
        oauth.should_receive(:authorize_from_request).with('fake_token', 'fake_secret', 'fake_oauth_verifier')
        oauth.should_receive(:access_token).and_return(mock_token)

        MyWeibo.fetch.auth('fake_oauth_verifier')

        my_weibo = MyWeibo.fetch
        my_weibo.oauth_token.should_not be_nil
        my_weibo.oauth_token.should == 'mock_token'
        my_weibo.oauth_secret.should_not be_nil
        my_weibo.oauth_secret.should == 'mock_secret'
      end
    end
  end
end

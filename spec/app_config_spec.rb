require 'spec_helper'

describe APP_CONFIG do
  it "APP_CONFIG['twitter_consumer_key']" do
    APP_CONFIG['twitter_consumer_key'].should == 'fake_consumer_key'
  end

  it "APP_CONFIG['twitter_consumer_secret']" do
    APP_CONFIG['twitter_consumer_secret'].should == 'fake_consumer_secret'
  end
end

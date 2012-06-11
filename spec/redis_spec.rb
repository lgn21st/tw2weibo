require 'spec_helper'

describe 'Redis' do
  def redis
    Ohm.redis
  end

  it "can be able to save and retrieve value by key" do
    key = 'Foo'
    value = 'Bar'
    redis.get(key).should be_nil
    redis.set(key, value)
    redis.get(key).should_not be_nil
    redis.get(key).should == value
  end

  it "shold be empty before test" do
    redis.keys.should be_empty
  end
end

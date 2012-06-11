require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require 'rack/test'

Ohm.connect :port => 6380

module RSpecMixin
  include Rack::Test::Methods

  def app
    MyApp
  end
end

RSpec.configure do |c|
  c.include RSpecMixin
  c.before(:each) { Ohm.flush }
end

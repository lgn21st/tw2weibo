require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require 'rack/test'

module RSpecMixin
  include Rack::Test::Methods

  def app
    MyApp
  end
end

RSpec.configure { |c| c.include RSpecMixin }

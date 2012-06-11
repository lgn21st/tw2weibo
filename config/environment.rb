require 'rubygems'
require 'bundler/setup'

require 'sinatra/base'
require "sinatra/reloader"

require 'ohm'

require 'weibo'

$LOAD_PATH.unshift File.expand_path('./models')
require 'my_twitter'
require 'my_weibo'

require 'debugger'


require File.join(File.dirname(__FILE__), '..', 'my_app')

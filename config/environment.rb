require 'rubygems'
require 'bundler/setup'

require 'sinatra/base'
require "sinatra/reloader"
require 'sinatra/base'

require 'ohm'

require 'weibo'
require 'tweetstream'
require 'yajl'


$LOAD_PATH.unshift File.expand_path('./models')

require 'base_model'
require 'my_twitter'
require 'my_weibo'

require 'debugger'

env = ENV['RACK_ENV'] || 'development'
APP_CONFIG = YAML.load_file('config/settings.yml')[env]

require File.join(File.dirname(__FILE__), '..', 'my_app')

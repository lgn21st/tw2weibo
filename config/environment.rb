require 'rubygems'
require 'bundler/setup'

require 'sinatra/base'
require "sinatra/reloader"

require 'weibo'

require File.join(File.dirname(__FILE__), '..', 'my_app')

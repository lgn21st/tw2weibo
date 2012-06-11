require 'rubygems'
require 'bundler/setup'

require 'sinatra/base'

require File.join(File.dirname(__FILE__), 'my_app')
run MyApp

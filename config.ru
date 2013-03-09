#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

require './lib/web'

$PROGRAM_NAME = 'radio_web'

run Web::App

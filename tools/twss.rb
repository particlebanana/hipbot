#!/usr/bin/env ruby

require 'rubygems'
require 'twss'
require 'base64'

TWSS.threshold = 5.0
puts TWSS(Base64.decode64(ARGV.first))
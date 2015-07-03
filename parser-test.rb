#!/usr/bin/env ruby

require 'parser/current'

code = Dir.glob "#{__dir__}/kintama/scripts/*"

code.each do |path|
  file = File.read path
  puts file
  p Parser::CurrentRuby.parse(file)
  p Parser::CurrentRuby.parse(file).to_hash
  puts "\n---\n"
end

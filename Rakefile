require 'rake'
require 'moneta'

@storage = Moneta.new :File, dir: "#{__dir__}/lib/.self_identity"

task :print, :script do |t, args|
  ['calls', 'returns', 'dependencies'].each do |data|
    puts "  #{data}"
    p @storage.fetch("#{args[:script]}-#{data}", 'nothing found')
    puts "\n"
  end
end

task 

task :test do
  require_relative 'kintama/self_identity'
end

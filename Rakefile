require 'rake'
require 'moneta'

@storage_dir = "#{__dir__}/lib/.self_identity"

task :print, :script do |t, args|
  storage = Moneta.new :File, dir: @storage_dir
  ['calls', 'returns', 'dependencies'].each do |data|
    puts "  #{data}"
    p storage.fetch("#{args[:script]}-#{data}", 'nothing found')
    puts "\n"
  end
end

task :list do
  entries = Dir.glob("#{@storage_dir}/*")
  entries.map! { |path| File.basename path }
  entries.map! { |path| path.split('-').first }
  puts entries.uniq
end

task :test do
  require_relative 'kintama/self_identity'
end

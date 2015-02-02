require 'rake'
require 'moneta'

task :check_storage do
  storage = Moneta.new :File, dir: '.self_identity'
  p storage['calls'], storage['returns'], storage['dependencies']
end

task :test do
  require_relative 'kintama/self_identity'
end
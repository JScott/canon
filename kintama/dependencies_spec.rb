require 'kintama'
require 'yaml'
require 'moneta'
#require_relative 'helpers'

$scripts = YAML.load_file "#{__dir__}/script_expectations.yaml"
puts $scripts.inspect, '---'

given 'self_identity is required' do
  #include ScriptHelper

  setup do
    @script_dir = "#{__dir__}/scripts"
    @storage = Moneta.new :File, dir: '.self_identity'
  end
  
  $scripts.each do |script|
    context "running scripts for #{script['name']}" do
      setup do
        script_path = "#{@script_dir}/#{script['name']}.rb"
        thread = Thread.new { system "ruby #{script_path}" }
        thread.join
      end

      ['calls', 'returns', 'dependencies'].each do |data|
        should "save method #{data}" do
          actual = @storage.fetch data, []
          assert_equal script[data], actual
        end
      end
    end
  end
end
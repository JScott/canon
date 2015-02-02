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

      should "save method dependencies" do
        actual = @storage.fetch 'dependencies', []
        assert_equal script['dependencies'], actual
      end
    end
  end
end
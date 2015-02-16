require 'kintama'
require 'yaml'
require 'moneta'
#require_relative 'helpers'
# TODO: clean this up with helpers and such

$scripts = YAML.load_file "#{__dir__}/expected/dependencies.yaml"

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

      should "calculate method dependencies" do
        actual = @storage.fetch 'dependencies', []
        assert_equal script['dependencies'], actual
      end
    end
  end
end
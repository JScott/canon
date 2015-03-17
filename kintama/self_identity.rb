require 'kintama'
require 'yaml'
require 'moneta'
#require_relative 'helpers'
# TODO: clean this up with helpers and such

$scripts = YAML.load_file "#{__dir__}/expected/outcomes.yaml"

def remove_reference_keys_for(hash)
  hash.reject! { |key| key.match /reference/ }
end

given 'self_identity is required' do
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
        if script[data]
          should "archive method #{data}" do
            actual = @storage.fetch data, []
            actual.each { |hash| remove_reference_keys_for hash }
            assert_equal script[data], actual
          end
        end
      end
    end
  end
end

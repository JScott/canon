require 'kintama'
require 'yaml'
require 'moneta'
#require_relative 'helpers'
# TODO: clean this up with helpers and such

$scripts = YAML.load_file "#{__dir__}/expected/outcomes.yaml"

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

      if script['dependencies']
        should "calculate method dependencies" do
          actual = @storage.fetch 'dependencies', []
          assert_equal script['dependencies'], actual
        end
      end

      ['calls', 'returns'].each do |data|
        if script[data]
          should "archive method #{data}" do
            actual = @storage.fetch data, []
            actual.each do |datum|
              datum.reject! { |key| key.match /reference/ }
            end
            # TODO: pull request for kintama with assert_empty
            assert_equal script[data], actual
          end
        end
      end
    end
  end
end
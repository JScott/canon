require 'rake'
require 'moneta'
require 'terminal-table'

def new_table(title, with_data:)
  headings = with_data.first.keys
  headings.map! { |heading| heading.to_s }
  Terminal::Table.new title: title, headings: headings do |t|
    with_data.each { |hash| t.add_row hash.values }
  end
end

task :check_storage do
  storage = Moneta.new :File, dir: '.self_identity'
  tables = []
  ['dependencies', 'calls', 'returns'].each do |data_type|
    data = storage[data_type]
    data.each do |hash|
      hash.reject! { |key| key =~ /reference/ }
    end
    tables.push new_table(data_type, with_data: data)
  end
  puts tables.join "\n\n"
end

task :test do
  require_relative 'kintama/self_identity'
end
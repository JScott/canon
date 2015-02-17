require 'rake'
require 'moneta'
require 'terminal-table'

def new_table(title, populate_with:, hiding:)
  headings = populate_with.first.keys
  headings.reject! { |heading| heading.match hiding }
  headings.map! { |heading| heading.to_s }
  Terminal::Table.new title: title, headings: headings do |t|
    populate_with.each do |hash|
      hash.reject! { |key| key.match hiding }
      t.add_row hash.values
    end
  end
end

task :print do
  storage = Moneta.new :File, dir: '.self_identity'
  tables = []
  ['dependencies', 'calls', 'returns'].each do |data_type|
    data = storage[data_type]
    table = new_table data_type, populate_with: data, hiding: /reference/
    tables.push table
  end
  puts tables.join "\n\n"
end

task :test do
  require_relative 'kintama/self_identity'
end
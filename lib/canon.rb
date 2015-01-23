require 'moneta'


established_canon = false
storage = Moneta.new :File, dir: '.canon'

puts '---', "Identity: #{storage.fetch 'identity', []}"
puts '---', "Output deps: #{storage.fetch 'method_dependencies', []}"

storage.delete 'identity'
storage.delete 'method_dependencies'

puts '---', "Established Canon is\n#{storage.fetch 'canon', []}"
storage.delete 'canon' unless established_canon


def output_dependencies(previous_method_calls, method_call)
  puts "Checking deps for #{method_call[:name]}"
  dependencies = []
  previous_method_calls.each do |previous_method_call|
    output = previous_method_call[:output]
    method_call[:input].each do |input|
      #puts "i: #{input.inspect} (#{input.object_id})"
      #puts "o: #{output.inspect} (#{output.object_id})"
      link = [previous_method_call[:name], method_call[:name]]
      dependencies.push link if output == input
    end
  end
  dependencies
end

TracePoint.trace do |t|
  identity = storage.fetch 'identity', []
  method_dependencies = storage.fetch 'method_dependencies', []
  case t.event
  when :return, :b_return
    parameters = t.binding.eval "method(__method__).parameters.map { |p| eval p.last.to_s }"
    method_call = { name: t.method_id, input: parameters, output: t.return_value }
    output_dependencies = output_dependencies(identity, method_call)

    method_dependencies.concat output_dependencies unless output_dependencies.empty?
    identity.push method_call
  end
  storage.store 'identity', identity
  storage.store 'canon', identity unless established_canon
  storage.store 'method_dependencies', method_dependencies
end

# don't put anything here unless you want it traced

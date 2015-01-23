require 'moneta'


established_canon = false
storage = Moneta.new :File, dir: '.canon'

puts '---', "Identity\n#{storage.fetch 'identity', []}"
puts '---', "Method dependencies\n#{storage.fetch 'method_dependencies', []}"
puts '---', "Established Canon is\n#{storage.fetch 'canon', []}"

storage.delete 'identity'
storage.delete 'method_dependencies'
storage.delete 'canon' unless established_canon

def trace_output(previous_method_calls, method_call)
  dependencies = []
  previous_method_calls.each do |previous_method_call|
    output = previous_method_call[:output]
    method_call[:input].each do |input|
      link = {
        output: previous_method_call[:output],
        from: previous_method_call[:name],
        to: method_call[:name]
      }
      dependencies.push link if output == input
    end
  end
  dependencies
end

TracePoint.trace do |t|
  previous_method_calls = storage.fetch 'identity', []
  method_dependencies = storage.fetch 'method_dependencies', []
  case t.event
  when :return  #, :b_return
    parameters = t.binding.eval "method(__method__).parameters.map { |p| eval p.last.to_s }"
    method_call = { name: t.method_id, input: parameters, output: t.return_value }
    output_dependencies = trace_output previous_method_calls, method_call

    method_dependencies.concat output_dependencies unless output_dependencies.empty?
    previous_method_calls.push method_call
  end
  storage.store 'identity', previous_method_calls
  storage.store 'method_dependencies', method_dependencies
  storage.store 'canon', previous_method_calls unless established_canon
end

# don't put anything here unless you want it traced

require 'moneta'


established_canon = false
storage = Moneta.new :File, dir: '.canon'

puts '---', "Identity\n#{storage.fetch 'identity', []}"
puts '---', "Method dependencies\n#{storage.fetch 'method_dependencies', []}"
puts '---', "Established Canon is\n#{storage.fetch 'canon', []}"

def trace_output(from_method_calls: [], to:)
  matches = from_method_calls.select do |previous_method_call|
    to[:input].index { |input| input.equal? previous_method_call[:output] }
  end
  matches.map do |match|
    {
      output: match[:output],
      from: match[:name],
      to: to[:name]
    }
  end
end

TracePoint.trace do |t|
  @identity ||= []
  method_dependencies = storage.fetch 'method_dependencies', []
  case t.event
  when :return
    parameters = t.binding.eval "method(__method__).parameters.map { |p| eval p.last.to_s }"
    method_call = { name: t.method_id, input: parameters, output: t.return_value }
    output_dependencies = trace_output from_method_calls: @identity, to: method_call

    method_dependencies.concat output_dependencies unless output_dependencies.empty?
    @identity.push method_call
  when :b_return, :c_return
  else
  end
  storage.store 'identity', @identity
  storage.store 'method_dependencies', method_dependencies.uniq
  storage.store 'canon', @identity unless established_canon
end

# don't put anything here unless you want it traced

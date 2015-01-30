require 'moneta'

established_canon = false
storage = Moneta.new :File, dir: '.canon'

puts '---', "Identity\n#{storage.fetch 'identity', []}"
puts '---', "Method dependencies\n#{storage.fetch 'dependencies', []}"
puts '---', "Established Canon is\n#{storage.fetch 'canon', []}"

def match_output_to_input(previous_method_calls, current)
  previous_method_calls.select do |previous|
    current[:input].detect { |given_input| given_input.equal? previous[:output] }
  end
end

def output_dependencies(from_method_calls:, to:)
  matches = match_output_to_input(from_method_calls, to)
  matches.map do |match|
    {
      output: match[:output],
      from: match[:name],
      to: to[:name]
    }
  end
end

def new_method_call(from:)
  parameters = from.binding.eval "method(__method__).parameters.map { |p| eval p.last.to_s }"
  {
    name: from.method_id,
    input: parameters,
    output: from.return_value
  }
end

TracePoint.trace do |trace|
  @identity ||= []
  @dependencies ||= []
  case trace.event
  when :return
    method_call = new_method_call from: trace
    @dependencies.concat output_dependencies from_method_calls: @identity, to: method_call
    @identity.push method_call
  when :b_return, :c_return
  else
  end
  storage.store 'identity', @identity
  storage.store 'dependencies', @dependencies
  storage.store 'canon', @identity unless established_canon
end

# don't put anything here unless you want it traced

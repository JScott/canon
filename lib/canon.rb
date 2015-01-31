require 'moneta'

storage = Moneta.new :File, dir: '.canon'

puts '---', "Method calls\n#{storage.fetch 'calls', []}"
puts '---', "Method returns\n#{storage.fetch 'returns', []}"
puts '---', "Method dependencies\n#{storage.fetch 'dependencies', []}"

#def match_output_to_input(previous_method_calls, current)
#  previous_method_calls.select do |previous|
#    current[:input].detect { |given_input| given_input.equal? previous[:output] }
#  end
#end

#def output_dependencies(from_method_calls:, to:)
#  #puts '---', from_method_calls.inspect, to.inspect
#  matches = match_output_to_input(from_method_calls, to)
#  matches.map do |match|
#    {
#      output: match[:output],
#      from: match[:name],
#      to: to[:name]
#    }
#  end
#end

def new_method_call(from:)
  parameters = from.binding.eval "method(__method__).parameters.map { |p| eval p.last.to_s }"
  {
    name: from.method_id,
    input: parameters
  }
end

def new_method_return(from:)
  {
    name: from.method_id,
    output: from.return_value
  }
end

def trace_method_calls_to(method_return)
  []
end

TracePoint.trace do |trace|
  @calls ||= []
  @returns ||= []
  @dependencies ||= []
  case trace.event
  when :call
    parameters = trace.binding.eval "method(__method__).parameters.map { |p| eval p.last.to_s }"
    @calls.push new_method_call(from: trace)
  when :return
    method_return = new_method_return from: trace
    @dependencies.concat trace_method_calls_to(method_return)
    #@dependencies.concat output_dependencies from_method_calls: @identity, to: method_call
    #@dependencies.concat internal_dependencies from_method_calls: @identity, to: method_call
    @returns.push method_return
  when :b_return, :c_return
  else
  end
  storage.store 'calls', @calls
  storage.store 'returns', @returns
  storage.store 'dependencies', @dependencies
end

# don't put anything here unless you want it traced

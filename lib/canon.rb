require 'moneta'

storage = Moneta.new :File, dir: '.self_identity'

#puts '---', "Method calls\n#{storage.fetch 'calls', []}"
#puts '---', "Method returns\n#{storage.fetch 'returns', []}"
#puts '---', "Method dependencies\n#{storage.fetch 'dependencies', []}"

def new_method_call(from:)
  parameters = from.binding.eval "method(__method__).parameters.map { |p| eval p.last.to_s }"
  {
    name: from.method_id,
    input_reference: parameters,
    input: parameters.map(&:clone)
  }
end

def new_method_return(from:)
  {
    name: from.method_id,
    output_reference: from.return_value,
    output: from.return_value.clone
  }
end

def returns_that_pass_to(current)
  @returns.select do |previous|
    current[:input_reference].detect { |given_input| given_input.equal? previous[:output_reference] }
  end
end

def dependencies_for(method_call)
  returns_that_pass_to(method_call).map do |method_return|
    {
      output: method_return[:output],
      from: method_return[:name],
      to: method_call[:name]
    }
  end
end

TracePoint.trace do |trace|
  @calls ||= []
  @returns ||= []
  @dependencies ||= []
  case trace.event
  when :call
    method_call = new_method_call from: trace
    puts "METHOD CALL: #{method_call}"
    @dependencies.concat dependencies_for(method_call)
    puts "METHOD DEP: #{@dependencies.last}"
    @calls.push method_call
  when :return
    @returns.push new_method_return(from: trace)
    puts "METHOD RETURN: #{@returns.last}"
  when :b_return, :c_return
  else
  end
  storage.store 'calls', @calls
  storage.store 'returns', @returns
  storage.store 'dependencies', @dependencies
  #puts "--- endgame vvv", @calls.inspect, @returns.inspect, @dependencies.inspect, '^^^'
end

# don't put anything here unless you want it traced

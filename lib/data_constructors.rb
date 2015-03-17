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
    output: from.return_value ? from.return_value.clone : nil
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

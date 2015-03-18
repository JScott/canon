def safe_clone(object)
  begin
    object.clone
  rescue TypeError => e
    object
  end
end

def sanitize(object)
  if object.is_a? Proc
    object.to_s
  else
    safe_clone object
  end
end

def new_method_call(from:)
  parameters = from.binding.eval "method(__method__).parameters.map { |p| eval p.last.to_s }"
  {
    name: from.method_id,
    input_reference: parameters.map(&:object_id),
    input: parameters.map { |parameter| sanitize parameter }
  }
end

def new_method_return(from:)
  {
    name: from.method_id,
    output_reference: from.return_value.object_id,
    output: sanitize(from.return_value)
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

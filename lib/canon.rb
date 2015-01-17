require 'moneta'


established_canon = false
storage = Moneta.new :File, dir: '.canon'
storage.delete 'identity'

puts "Established Canon is\n#{storage.fetch 'canon', []}\n---\n"
storage.delete 'canon' unless established_canon

TracePoint.trace do |t|
  identity = storage.fetch 'identity', []
  case t.event
  when :return, :b_return
    get_parameters = "method(__method__).parameters.map { |p| eval p.last.to_s }"
    parameters = t.binding.eval get_parameters
    identity.push method: t.method_id, input: parameters, output: t.return_value
  end
  storage.store 'identity', identity
  storage.store 'canon', identity unless established_canon

  p identity if identity.any?
  #explore storage for where this input came from
  # add this method to 
end

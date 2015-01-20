require 'moneta'


established_canon = false
storage = Moneta.new :File, dir: '.canon'
storage.delete 'identity'
storage.delete 'method_chain'

puts "Established Canon is\n#{storage.fetch 'canon', []}\n---\n"
storage.delete 'canon' unless established_canon


TracePoint.trace do |t|
  identity = storage.fetch 'identity', []
  method_chain = storage.fetch 'method_chain', []
  case t.event
  when :return, :b_return
    get_parameters = "method(__method__).parameters.map { |p| eval p.last.to_s }"
    parameters = t.binding.eval get_parameters
    method_call = { name: t.method_id, input: parameters, output: t.return_value }
    
    identity.each do |method|
      puts '>>>'
      method[:input].each do |input|
        output = method[:output]
        puts "Running #{method[:name]}"
        puts "A: #{input.inspect} (#{input.object_id})"
        puts "B: #{output.inspect} (#{output.object_id})"
        other_methods = identity.reject { |m| m == method }
        puts other_methods.inspect
      end
      puts '<<<'
    end
    puts "=== MASTER POKE ==="
    
    identity.push method_call
    #puts identity.inspect
  end
  storage.store 'identity', identity
  storage.store 'method_chain', method_chain
  storage.store 'canon', identity unless established_canon

  #p identity if identity.any?
  #explore storage for where this input came from
  # add this method to 
end

# don't put anything here unless you want it traced

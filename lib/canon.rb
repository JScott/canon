require 'moneta'

established = Dir.exists? '.canon'

archives = Moneta.new :File, dir: '.canon'
p "Canonical Execution Established as #{archives.fetch 'canon', []}"

TracePoint.trace do |t|
  canon = archives.fetch 'canon', []
  case t.event
  when :return, :b_return
    parameters = t.binding.eval "p method(__method__).parameters.map { |p| eval p.last.to_s }"
    canon << [t.method_id, parameters, t.return_value]
  end
  archives.store 'canon', canon unless established
end

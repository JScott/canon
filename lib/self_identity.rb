require 'moneta'
require_relative 'data_constructors'

storage = Moneta.new :File, dir: '.self_identity'
storage['calls'] = []
storage['returns'] = []
storage['dependencies'] = []

$trace = TracePoint.trace do |trace|
  @calls ||= []
  @returns ||= []
  @dependencies ||= []
  case trace.event
  when :call
    method_call = new_method_call from: trace
    @dependencies.concat dependencies_for(method_call)
    @calls.push method_call
  when :return
    @returns.push new_method_return(from: trace) unless trace.method_id == :require
  when :b_return
    # not sure how to hook into method blocks
    # __method__ returns the method it was called from
  when :c_return
    # might need a C extension to hook into C calls
    # __method__ returns 'main'
  else
  end
  storage.store 'calls', @calls
  storage.store 'returns', @returns
  storage.store 'dependencies', @dependencies
end

module SelfIdentity
  @@trace = $trace

  def self.enabled?
    @@trace.enabled?
  end

  def self.enable(&block)
    @@trace.enable &block
  end

  def self.disable(&block)
    @@trace.disable &block
  end
end

$trace = nil

# don't put anything here unless you want it traced

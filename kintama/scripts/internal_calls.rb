require_relative '../../lib/self_identity'

def foo(array)
  array.push 1
end

def bar(array)
  baz array
  array.push 2
end

def baz(array)
  'whatever'
end

var = foo []
var = bar var
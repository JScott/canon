require_relative '../../lib/canon'

def foo(array)
  array.push 1
end

def bar(array)
  array.push 2
end

var = foo []
var = bar var
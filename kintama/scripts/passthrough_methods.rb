require_relative '../../lib/self_identity'

def foo(array)
  array.push 1
end

def bar(array)
  # do work with array
  array
end

def baz(array)
  array.push 2
end

var = foo []
var = bar var
var = baz var
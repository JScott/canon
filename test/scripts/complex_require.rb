require_relative '../../lib/self_identity'
require 'robot_sweatshop'

def foo(array)
  array.push 1
end

def bar(array)
  array.push 2
end

var = foo []
var = bar var

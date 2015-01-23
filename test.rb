require_relative 'lib/canon'
#require 'stringio'
#STDOUT.reopen '/dev/null','w'

def foo(string = '')
  string.to_sym
end

def bar(symbol = :empty)
  [symbol]
end

def baz(array = [])
  array.map { |item| "#{item.to_s} world!" }
end

var = foo 'Hello'
var = bar var
var = baz var
#var = baz [:Hello]

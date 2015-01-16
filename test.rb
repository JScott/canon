require_relative 'lib/canon'
#require 'stringio'
#STDOUT.reopen '/dev/null','w'

def foo(string = '')
  string.to_sym
end

def bar(symbol = :empty)
  [symbol]
end

var = foo 'Hello'
var = bar var


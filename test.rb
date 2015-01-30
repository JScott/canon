require_relative 'lib/canon'

def foo(string = '')
  string.to_sym
end

def arrayify(symbol)
  [symbol]
end
def bar(symbol = :empty)
  arrayify symbol
end

# for some reason it thinks that this input is [:Hello, 2], not [:Hello]
def passthru(anything)
  #anything = something + [2]    # works as expected! overwriting?
  anything = anything + [2]
  a = arrayify anything
  anything
end

def baz(array = [])
  array.map { |item| "#{item.to_s} world!" }
end

var = foo 'Hello'   # Gets recorded to the identity
var = bar var       # Creates dependency foo->bar
var = passthru var
var = baz var       # Created dependency bar->baz
var = baz [:Hello]  # Same value but isn't a dependency for bar!

self_identity
=============

Helping code understand itself, an adventure in alternative testing methodology.

Usage
-----

`require 'self_identity'` and your code will record its method dependencies each time it runs. Be sure to add this _after_ any requires. It trips TracePoint up and we haven't figured out a solution for it yet. If you can't do this, add `SelfIdentity.`

From the working directory the script was run from, you'll find [Moneta](https://github.com/minad/moneta) file stores under `.self_identity` with arrays of the following element formats:

### calls

- __name__: the method called
- __input_reference__: object_id's of the input
- __input__: the given input array

### returns

- __name__: the method returned from
- __output_reference__: object_id of the output
- __output__: the generated output

### dependencies

- __output__: the object passed between the methods
- __from__: the method returned from
- __to__: the method called

Background
----------

At the end of 2014, @brixen posted a fascinating rant on the state of RubySpec. One bit stuck out as inspiring: "Ruby is what Ruby does."

MRI 1.8 had pretty spotty (or no) test coverage. When confirming the accuracy of Rubinius in the face of an absent or incomplete test suite, @brixen asserted that "The way a Ruby program behaves is the definition of Ruby". From this assertion came RubySpec, a comprehensive suite of specifications describing "what Ruby does" so alternative implementations could do the same thing.

self_identity applies this mindset to automated testing.

Objectives
----------

1. Be able to define method signatures. Given input x (of type a) to method m, the output will be y (of type b).
2. Be able to define what qualifies as valid input. For input x, what is it required to ```respond_to?``` within method m.
3. Be able to define what qualifies as valid output. For output y from method m, what will it be expected to ```respond_to?``` from creation until it is reaped by the garbage collection valkyries.

_Together, these allow a program to assert its identity: the collection of canonical method signatures and object interactions that state "This is what I am, and how I operate."_

Notes
-----

This is not a replacement for *good* tests, or specs. It does not validate that the code is correct (beyond the syntax checking inherent in running the program), or that it performs as expected. However, being able to assert that "it did what it did last time, given the same conditions" is better than untested code.

Authors
-------

Chris Olstrom and Justin Scott

self_identity
=============

Tests that write themselves, an adventure in alternative testing methodology.

Status
------

Incomplete implementation, working towards a proof of concept. Barely tested, has no stable API, and is probably broken.

This is a work in progress!

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

_Together, these define a program to assert its identity: the collection of canonical method signatures and object interactions that state "This is what I am, and how I operate."_

Notes
-----

This is not a replacement for *good* tests, or specs. It does not validate that the code is correct (beyond the syntax checking inherent in running the program), or that it performs as expected. However, being able to assert that "it did what it did last time, given the same conditions" is better than untested code.

Authors
-------

Chris Olstrom and Justin Scott

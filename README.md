Canon
=====

Tests that write themselves, an adventure in alternative testing methodology.

Status
------

Unstable, barely tested, probably broken. Work In Progress!

Background
----------

At the end of 2014, @brixen posted a fascinating rant on the state of RubySpec. One bit stuck out as inspiring: "Ruby is what Ruby does."

MRI 1.8 had pretty spotty (or no) test coverage. When confirming the accuracy of Rubinius in the face of an absent or incomplete test suite, @brixen asserted that "The way a Ruby program behaves is the definition of Ruby". From this assertion came RubySpec, a comprehensive suite of specifications describing "what Ruby does" so alternative implementations could do the same thing.

Canon applies this mindset to automated testing.

At runtime, we trace methods called, parameters passed to them, and the returns. From this, we define canonical method signatures and can compare future runs against canon.

This is not a replacement for *good* tests, or specs. This is however, better than no tests. Being able to assert that "it did what it did last time, given the same conditions" is marginally better than untested code.

Authors
-------

Chris Olstrom and Justin Scott

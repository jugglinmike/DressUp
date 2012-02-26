CSS Packer
==========

Pack CSS rules into JavaScript files.

Description
-----------

This repository is meant to serve as a demonstration of the method described in
the article, "CSS in Third Party JavaScript Applications".

Implementations
---------------

The technique is implemented in three scripting langauges:

* Perl
* Ruby
* JavaScript (requires Node.js)

Execution instructions
----------------------

Each implementation is run from the command line, and accepts an arbitrary number of arguments. Each argument should be a path (relative or absolute) to a JavaScript (.js) or CSS (.css) file. For example:

`src/ruby/pack.rb test/sample_input/widget1.js test/sample_input/widget1.css`

Of course, if file globs are available in your environment, the above may be simplified to:

`src/ruby/pack.rb test/sample_input/widget1.*`

Tests
-----

High-level acceptance tests for each implementation can be found in the /test directory.

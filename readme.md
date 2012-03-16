CSS Packer
==========

Automatically import CSS into your JavaScript files!

Why
---

This repository was created to support the process described in the article, "CSS in Third-Party JavaScript Applications: Importing".
The text of this article is available in the "why.md" file in this repository.

How
---

The scripts operate with a very simple find-and-replace algorithm, looking for two directives in the input JavaScript file(s): `!import_rule` and `!import_file`.
It includes the specified CSS without breaking the JavaScript (specifically, removing newlines and escaping the appropriate quotation marks.
This functionality has been implemented in Perl, Ruby, and JavaScript (via Node.js).

Each implementation is run from the command line, and accepts an arbitrary number of arguments. Each argument should be a path (relative or absolute) to a JavaScript (.js) or CSS (.css) file. For example:

    src/ruby/pack.rb test/sample_input/widget1.js test/sample_input/widget1.css

Of course, if file globs are available in your environment, the above may be simplified to:

    src/ruby/pack.rb test/sample_input/widget1.*

Tests?
------

Good question!
This project is backed by acceptance tests; you can run these with `make test` (to test all implementations). `make testperl`, `make testruby`, and `make testjs` (to test specific implementations).
The tests require the "grep" utility.

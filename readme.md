DressUp
=======

Automatically import CSS into your JavaScript files.

Why
---

This repository was created to help optimize performance of third-party JavaScript applications.
A more thorough review of the motivation can be found in the article "CSS in Third-Party JavaScript Applications: Importing", originally published on the Bocoup blog.

How
---

The build process includes the specified CSS without breaking the JavaScript (specifically, removing newlines and escaping the appropriate quotation marks.
CSS compression is highly recommended and should take place in an intermediary step prior to this process.
This functionality has been implemented in Perl, Ruby, and JavaScript (via Node.js).
These scripts implement a very simple find-and-replace algorithm, looking for two directives in the input JavaScript file(s): `!import_rule` and `!import_file`.

From the JavaScript
-------------------

String literals containing the previously-mentioned directives will be used as expansion targets.

*Including rules.*

To include a specific CSS rule (i.e. `div.mike`) in a JavaScript file:

    var myRule = "!import_rule div.mike";

...this would yield JavaScript like:

    var myRule = "background-color:#a00;z-index: 4;";

When building, be sure to supply a CSS file which defines the specified rule (more on this in the next section).

*Including stylesheet files.*

To import a complete stylesheet file (i.e. `mark.css`) in a JavaScript file:

    var mySheet = "!import_file ../styles/mark.css";

...this would yield JavaScript like:

    var mySheet = "div.mark { height: 120%; } div.matt { float: right; }";

Please note that the file path is interpreted in relation to the JavaScript file's location.

If either of these directives end with the `!important` keyword, every imported statement will be declared as `!important`.
For instance, by re-writing the previous example:

    var mySheet = "!import_file ../styles/mark.css !important";

...the following JavaScript file would be built:

    var mySheet = "div.mark { height: 120% !important; } div.matt { float: right !important; }";

From the command line
---------------------

*Arguments.* Each implementation is run from the command line, and accepts an arbitrary number of arguments.
Each argument should be a path (relative or absolute) to a JavaScript (.js) or CSS (.css) file.
For example:

    src/dressup.rb test/input/import_rule.js test/input/import_rule.css

Of course, if file globs are available in your environment, the above may be simplified to:

    src/dressup.rb test/input/import_rule.*

If importing one or more CSS rules via the `import_rule` syntax, be sure to supply the script with a CSS file that defines those rules!

*Output.* The built JavaScript is printed to standard out.
If more than one JavaScript file is specified as input, a concatenation of the built versions of these files will be output.

Tests?
------

Good question!
This project is backed by acceptance tests; you can run these with `make test` (to test all implementations). `make testperl`, `make testruby`, and `make testjs` (to test specific implementations).
The tests require the "grep" utility.

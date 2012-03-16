#
# Makefile for CSS build
# Right now just used to test

test: testruby testperl testjs
	echo ""

testruby:
	cd test; ./ruby.sh ruby

testperl:
	cd test; ./ruby.sh perl

testjs:
	cd test; ./ruby.sh js

.PHONY: test

#
# Makefile for CSS build
# Right now just used to test

test: testruby testperl testjs

testruby:
	cd test; ./runner.sh ruby

testperl:
	cd test; ./runner.sh perl

testjs:
	cd test; ./runner.sh js

.PHONY: test

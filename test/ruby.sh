#!/bin/bash

hasErrors=false

if ! ruby ../src/ruby/pack.rb data/input1.css data/input1.js | diff - data/output1.js > /dev/null
then
  echo 'Error!'
  hasErrors=true
fi

if ! ruby ../src/ruby/pack.rb data/input1.js data/input1.css | diff - data/output1.js > /dev/null
then
  echo 'Error!'
  hasErrors=true
fi

if $hasErrors
then
  exit 1
else
  echo 'All tests passed.'
  exit 0
fi

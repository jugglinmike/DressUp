#!/bin/bash

hasErrors=false
executable=""

function runTests()
{
  executable=$1;
  scriptFile=$2;

  echo "Running tests for $executable implementation...";

  if ! $executable $scriptFile data/input1.css data/input1.js | diff - data/output1.js > /dev/null;
  then
    echo 'Error!'
    hasErrors=true
  fi

  if ! $executable $scriptFile data/input1.js data/input1.css | diff - data/output1.js > /dev/null
  then
    echo 'Error!'
    hasErrors=true
  fi
}

if [ $# -gt 0 ]
then
	if [ $1 == "ruby" ]
	then
		runTests ruby ../src/pack.rb;
	elif [ $1 == "perl" ]
	then
		runTests perl ../src/pack.pl;
	elif [ $1 == "js" ]
	then
		runTests node ../src/pack.js;
	fi
else
	echo "Nada";
fi


if $hasErrors
then
  exit 1
else
  echo 'All tests passed.'
  exit 0
fi

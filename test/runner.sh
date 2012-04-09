#!/bin/bash

hasErrors=false
executable=""

function runTests()
{
  executable=$1;
  scriptFile=$2;

  echo "Running tests for $executable implementation...";

  if ! $executable $scriptFile input/import_rule.css input/import_rule.js | diff - expected/import_rule.js > /dev/null;
  then
  echo 'Failed test: import rule (CSS first)'
    hasErrors=true
  fi

  if ! $executable $scriptFile input/import_rule.js input/import_rule.css | diff - expected/import_rule.js > /dev/null;
  then
  echo 'Failed test: import rule (JavaScript first)'
    hasErrors=true
  fi

  if ! $executable $scriptFile input/import_rule.css input/import_important_rule.js | diff - expected/import_important_rule.js > /dev/null;
  then
  echo 'Failed test: import !important rule (CSS first)'
    hasErrors=true
  fi

  if ! $executable $scriptFile input/import_important_rule.js input/import_rule.css | diff - expected/import_important_rule.js > /dev/null;
  then
  echo 'Failed test: import !important rule (JavaScript first)'
    hasErrors=true
  fi

  if ! $executable $scriptFile input/arbitrary_directory/import_file.js | diff - expected/import_file.js > /dev/null;
  then
    echo 'Failed test: import file'
    hasErrors=true
  fi

  if ! $executable $scriptFile input/arbitrary_directory/import_important_file.js | diff - expected/import_important_file.js > /dev/null;
  then
    echo 'Failed test: import !important file'
    hasErrors=true
  fi

  $executable $scriptFile input/nonexistent_rule.js input/nonexistent_rule.css > /dev/null;
  if [[ $? != 1 ]] ; then
	  echo 'Failed test: import nonexistent rule';
	  hasErrors=true
  fi

  $executable $scriptFile input/nonexistent_file.js > /dev/null;
  if [[ $? != 1 ]] ; then
	  echo 'Failed test: import unreadable file';
	  hasErrors=true
  fi
}

if [ $# -gt 0 ]
then
	if [ $1 == "ruby" ]
	then
		runTests ruby ../src/dressup.rb;
	elif [ $1 == "perl" ]
	then
		runTests perl ../src/dressup.pl;
	elif [ $1 == "js" ]
	then
		runTests node ../src/dressup.js;
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

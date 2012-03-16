#!/bin/bash

hasErrors=false
executable=""

function runTests()
{
  executable=$1;
  scriptFile=$2;

  echo "Running tests for $executable implementation...";

  if ! $executable $scriptFile data/import_rule_in.css data/import_rule_in.js | diff - data/import_rule_out.js > /dev/null;
  then
  echo 'Failed test: import rule (CSS first)'
    hasErrors=true
  fi

  if ! $executable $scriptFile data/import_rule_in.js data/import_rule_in.css | diff - data/import_rule_out.js > /dev/null;
  then
  echo 'Failed test: import rule (JavaScript first)'
    hasErrors=true
  fi

  #if ! $executable $scriptFile data/import_rule_in.css data/import_important_rule_in.js | diff - data/import_important_rule_out.js > /dev/null;
  #then
  #echo 'Failed test: import !important rule (CSS first)'
  #  hasErrors=true
  #fi

  #if ! $executable $scriptFile data/import_important_rule_in.js data/import_rule_in.css | diff - data/import_important_rule_out.js > /dev/null;
  #then
  #echo 'Failed test: import !important rule (JavaScript first)'
  #  hasErrors=true
  #fi

  if ! $executable $scriptFile data/arbitrary_directory/import_file_in.js | diff - data/arbitrary_directory/import_file_out.js > /dev/null;
  then
    echo 'Failed test: import file'
    hasErrors=true
  fi

  $executable $scriptFile data/nonexistent_rule.js data/nonexistent_rule.css > /dev/null;
  if [[ $? != 1 ]] ; then
	  echo 'Failed test: import nonexistent rule';
	  hasErrors=true
  fi

  $executable $scriptFile data/nonexistent_file.js > /dev/null;
  if [[ $? != 1 ]] ; then
	  echo 'Failed test: import unreadable file';
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

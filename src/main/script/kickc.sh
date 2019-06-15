#!/bin/bash

# JAVA HOME
# KICKC HOME
export KICKC_HOME="$(dirname $0)/.."
# KCLIB HOME
export KICKC_STDLIB_HOME="$KICKC_HOME/stdlib"
# FRAGMENTS HOME
export KICKC_FRAGMENT_HOME="$KICKC_HOME/fragment"
# KICKASSEMBLER HOME
# VICE HOME
# KICKC_JAR
export KICKC_JAR=$KICKC_HOME/lib/kickc-*.jar

# Parse parameters (overriding defaults)
export PARAM="";
while [[ "$#" -gt 0 ]]; do case $1 in
  -F|--fragmentdir) export KICKC_FRAGMENT_HOME="$2"; shift; shift;;
  *) export PARAM="$PARAM $1"; shift;;
esac; done

echo java -jar $KICKC_JAR -I $KICKC_STDLIB_HOME -F $KICKC_FRAGMENT_HOME $PARAM
java -jar $KICKC_JAR -I $KICKC_STDLIB_HOME -F $KICKC_FRAGMENT_HOME $PARAM
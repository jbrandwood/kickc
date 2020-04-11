#!/bin/bash

# JAVA HOME
# KICKC HOME
export KICKC_HOME="$(dirname $0)/.."
# STANDARD INCLUDE
export KICKC_STD_INCLUDE="$KICKC_HOME/include"
# STANDARD LIBRARY
export KICKC_STD_LIB="$KICKC_HOME/lib"
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

echo java -jar $KICKC_JAR -F $KICKC_FRAGMENT_HOME $PARAM -I $KICKC_STD_INCLUDE -L $KICKC_STD_LIB
java -jar $KICKC_JAR -F $KICKC_FRAGMENT_HOME $PARAM -I $KICKC_STD_INCLUDE -L $KICKC_STD_LIB
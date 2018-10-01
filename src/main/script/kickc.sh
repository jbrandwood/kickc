#!/bin/bash

# JAVA HOME
# KICKC HOME
export KICKC_HOME="$(dirname $0)/.."
# KCLIB HOME
export KICKCLIB_HOME="$KICKC_HOME/stdlib"
# KICKASSEMBLER HOME
# VICE HOME
# KICKC_JAR
export KICKC_JAR=$KICKC_HOME/lib/kickc-*.jar

echo java -jar $KICKC_JAR -I $KICKCLIB_HOME $*
java -jar $KICKC_JAR -I $KICKCLIB_HOME $*
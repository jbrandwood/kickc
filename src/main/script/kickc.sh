#!/bin/bash

# JAVA HOME
# KICKC HOME
export KICKC_HOME="$(dirname $0)/.."
# KCLIB HOME
export KICKCLIB_HOME="$KICKC_HOME/stdlib"
# KICKASSEMBLER HOME
# VICE HOME

echo java -jar lib/kickc-0.5-SNAPSHOT.jar -I $KICKCLIB_HOME $*
java -jar lib/kickc-0.5-SNAPSHOT.jar -I $KICKCLIB_HOME $*
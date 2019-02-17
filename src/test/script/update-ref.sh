#!/usr/bin/env bash
# Update KickC Test Reference files
# Usage: update-ref <folder-output>
export REF_HOME="$(dirname $0)/../ref"
export UPD_HOME=$1
pushd ${UPD_HOME}
for i in $(find . -type f | grep -v '/bin/'); do echo ${i}; cp ${i} ${REF_HOME}/${i}; done
popd

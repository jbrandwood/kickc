#!/usr/bin/env bash
# Update KickC Test Reference files
# Usage: update-ref <folder-output>
export REF_HOME="$(dirname $0)/../ref"
export UPD_HOME=$1
echo References ${REF_HOME}
echo Updates ${UPD_HOME}
rm ${UPD_HOME}/update.sh
pushd ${UPD_HOME}
for i in $(find . -type f | grep -v '/bin/'); do echo cp ${UPD_HOME}/${i} ${REF_HOME}/${i} >> update.sh; done
popd
source ${UPD_HOME}/update.sh


#!/usr/bin/env bash
# Builds and deploys a local version of KickC
export C64_HOME="$(dirname $0)/../../../.."
pushd "${C64_HOME}/kickc"
mvn package -DskipTests
popd
rm -r ${C64_HOME}/kickc_local/*
unzip -d ${C64_HOME}/kickc_local ${C64_HOME}/kickc/target/kickc-release.zip
mv ${C64_HOME}/kickc_local/kickc/* ${C64_HOME}/kickc_local/

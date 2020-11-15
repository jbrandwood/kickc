#!/usr/bin/env bash

# Prepare by making the "official" metadata local
cp ./repo/dk/camelot64/kickass/xexplugin/kickassxexformat/maven-metadata.xml ./repo/dk/camelot64/kickass/xexplugin/kickassxexformat/maven-metadata-local.xml

# mvn install:install-file -Dmaven.repo.local=./repo/ -Dfile=/Applications/KickAssembler/KickAss.jar -DgroupId=cml.kickass -DartifactId=kickassembler -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true -Dversion=5.16
mvn install:install-file -Dmaven.repo.local=./repo/ -Dfile=/Users/jespergravgaard/c64/kickass-plugin-atari-xex/bin/KickAssXexFormat.jar -DgroupId=dk.camelot64.kickass.xexplugin -DartifactId=kickassxexformat -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true -Dversion=1.0

# Finalize by making the local metadata official
pushd ./repo/dk/camelot64/kickass/xexplugin/kickassxexformat
mv maven-metadata-local.xml maven-metadata.xml
mv maven-metadata-local.xml.md5 maven-metadata.xml.md5
mv maven-metadata-local.xml.sha1 maven-metadata.xml.sha1
popd

# Remove stuff that Maven adds, that we don't need
rm -rf ./repo/classworlds
rm -rf ./repo/junit
rm -rf ./repo/org

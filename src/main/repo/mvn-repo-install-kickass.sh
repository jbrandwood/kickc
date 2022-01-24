#!/usr/bin/env bash

# Prepare by making the "official" metadata local
cp ./repo/cml/kickass/kickassembler/maven-metadata.xml ./repo/cml/kickass/kickassembler/maven-metadata-local.xml

# mvn install:install-file -Dmaven.repo.local=./repo/ -Dfile=/Applications/KickAssembler/KickAss.jar -DgroupId=cml.kickass -DartifactId=kickassembler -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true -Dversion=5.16
mvn install:install-file -Dmaven.repo.local=./repo/ -Dfile=/Users/jespergravgaard/c64/kickassembler65ce02/out/KickAss65CE02.jar -DgroupId=cml.kickass -DartifactId=kickassembler -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true -Dversion=5.24-65ce02.a

# Finalize by making the local metadata official
pushd ./repo/cml/kickass/kickassembler
mv maven-metadata-local.xml maven-metadata.xml
mv maven-metadata-local.xml.md5 maven-metadata.xml.md5
mv maven-metadata-local.xml.sha1 maven-metadata.xml.sha1
popd

# Remove stuff that Maven adds, that we don't need
rm -rf ./repo/classworlds
rm -rf ./repo/junit
rm -rf ./repo/org

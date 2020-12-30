#!/usr/bin/env bash

# Prepare by making the "official" metadata local
cp ./repo/se/triad/kickass/kickass-cruncher-plugins/maven-metadata.xml ./repo/se/triad/kickass/kickass-cruncher-plugins/maven-metadata-local.xml

mvn install:install-file -Dmaven.repo.local=./repo/ -Dfile=/Users/jespergravgaard/c64/cruncher-plugins/releases/kickass-cruncher-plugins-2.0/kickass-cruncher-plugins-2.0.jar -DgroupId=se.triad.kickass -DartifactId=kickass-cruncher-plugins -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true -Dversion=2.0

# Finalize by making the local metadata official
pushd ./repo/se/triad/kickass/kickass-cruncher-plugins/
mv maven-metadata-local.xml maven-metadata.xml
mv maven-metadata-local.xml.md5 maven-metadata.xml.md5
mv maven-metadata-local.xml.sha1 maven-metadata.xml.sha1
popd

# Remove stuff that Maven adds, that we don't need
rm -rf ./repo/classworlds
rm -rf ./repo/junit
rm -rf ./repo/org

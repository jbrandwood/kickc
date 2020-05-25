#!/usr/bin/env bash
mvn install:install-file -Dmaven.repo.local=./repo/ -Dfile=/Applications/KickAssembler/KickAss.jar -DgroupId=cml.kickass -DartifactId=kickassembler -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true -Dversion=5.15

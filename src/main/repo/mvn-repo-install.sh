#!/usr/bin/env bash
# mvn install:install-file -Dmaven.repo.local=./repo/ -Dfile=/Applications/KickAssembler/KickAss.jar -DgroupId=cml.kickass -DartifactId=kickassembler -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true -Dversion=5.16
mvn install:install-file -Dmaven.repo.local=./repo/ -Dfile=/Users/jespergravgaard/c64/kickassembler65ce02/out/KickAss65CE02.jar -DgroupId=cml.kickass -DartifactId=kickassembler -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true -Dversion=5.16-65ce02.b

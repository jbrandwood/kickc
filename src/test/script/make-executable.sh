#!/bin/bash
# Remove the old files
rm -rf target/kickc
rm -rf target/java-runtime
rm -rf target/kickc.app
# Build the release ZIP
mvn package -DskipTests
# Unpackage the release ZIP
unzip target/kickc-release.zip -d target
# Create a minimal java runtime
jlink --output target/java-runtime --add-modules java.base,java.desktop
# Package a java application
jpackage --dest target --input target/kickc/jar/ --name kickc --main-jar kickc-release.jar --type app-image --runtime-image target/java-runtime
# Test the resulting application
target/kickc.app/Contents/MacOS/kickc -I target/kickc/include/ -F target/kickc/fragment/ -P target/kickc/target -L target/kickc/lib/ target/kickc/examples/helloworld/helloworld.c


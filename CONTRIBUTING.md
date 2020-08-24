# Contributing

When contributing to this repository, please first discuss the change you wish to make via issue,
facebook, or any other method with the owner of this repository before making a change. 

## Building KickC

The prerequisites for locally building KickC are the following

*  [Java OpenJDK 14+](https://www.oracle.com/technetwork/java/javase)
*  [Apache Maven 3+](https://maven.apache.org)

The steps to building KickC are

1.  Download, Fork or Clone the source code from https://gitlab.com/camelot/kickc 
2.  Build and package the KickC compiler by entering the source directory and executing `mvn package` 
    (if you want to skip the time-consuming tests you can add the option `-DskipTests`)
3. The zipped release is placed in `target/kickc-release.zip`. You can now unzip it to a folder of your choice to start using the compiler.




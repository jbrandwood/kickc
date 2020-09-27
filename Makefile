all:
	mvn package -DskipTests
test:
	mvn package
clean:
	mvn clean


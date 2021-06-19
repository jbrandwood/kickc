all:
	mvn package -DskipTests
test:
	mvn package
clean:
	mvn clean
doxygen:
	mkdir target
	doxygen src/main/doxygen/doxygen.conf


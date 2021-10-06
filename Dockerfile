# Build the app
FROM maven:3-adoptopenjdk-8 as compile

COPY ./lib ./lib
COPY ./pom.xml ./pom.xml
COPY ./src ./src
COPY ./haarcascades ./haarcascades

RUN mvn install
RUN mvn package

#COPY ./target/fatjar-0.0.1-SNAPSHOT.jar ./target/fatjar-0.0.1-SNAPSHOT.jar

# the command that'll be used when the image will be launched
# using docker run myapp...
CMD java -Djava.library.path=lib/ -jar target/fatjar-0.0.1-SNAPSHOT.jar
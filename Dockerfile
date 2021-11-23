# Build the app
FROM maven:3-adoptopenjdk-8 AS compile

COPY lib /home/app/lib
COPY pom.xml /home/app/pom.xml
COPY src /home/app/src
COPY haarcascades /usr/local/lib/

RUN mvn -f /home/app/pom.xml clean package -DskipTests=true

# Launch the app
FROM openjdk:8-jre-slim

COPY --from=compile /home/app/lib /usr/lib
# Copy the compiled app from previous stage to the current one
COPY --from=compile /home/app/target/fatjar-0.0.1-SNAPSHOT.jar /usr/local/lib/opencvapp.jar

# update libs links
RUN ldconfig /usr/local/lib

# the command that'll be used when the image will be launched
# using docker run myapp...
#ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["java", "-Djava.library.path=lib/opencv_java3410.jar", "-jar", "usr/local/lib/opencvapp.jar"]

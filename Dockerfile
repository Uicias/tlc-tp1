# Build the app
FROM ubuntu:16.04 AS compile

# Get all required dependencies
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y maven
RUN apt-get install -f libpng16-16
RUN apt-get install -f -y libjasper1
RUN apt-get install -f -y libdc1394-22

# Clone the project into /usr/app
RUN git clone https://github.com/barais/TPDockerSampleApp /usr/app

# Set /usr/app as current dir
WORKDIR /usr/app

# Package the app using maven
RUN mvn install:install-file package -Dfile=lib/opencv-3410.jar -DgroupId=org.opencv  -DartifactId=opencv -Dversion=3.4.10 -Dpackaging=jar

# Command ran when launching the container
CMD ["java", "-Djava.library.path=lib/", "-jar", "target/fatjar-0.0.1-SNAPSHOT.jar"]
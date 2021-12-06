# Build the app
FROM ubuntu:18.04 AS compile

RUN echo "deb http://security.ubuntu.com/ubuntu xenial-security main" | tee -a /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y maven
RUN apt-get install -f libpng16-16
RUN apt-get install -f -y libjasper1
RUN apt-get install -f -y libdc1394-22

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

#RUN git clone https://github.com/jasperproject/jasper-client.git jasper \ && chmod +x jasper/jasper.py \ && pip install --upgrade setuptools \ && pip install -r jasper/client/requirements.txt

RUN git clone https://github.com/barais/TPDockerSampleApp

COPY TPDockerSampleApp/pom.xml .

RUN mvn install:install-file package -Dfile=TPDockerSampleApp/lib/opencv-3410.jar -DgroupId=org.opencv  -DartifactId=opencv -Dversion=3.4.10 -Dpackaging=jar

# Launch the app
FROM openjdk:8-jre-slim

COPY --from=compile /home/app/lib /usr/lib
# Copy the compiled app from previous stage to the current one
COPY --from=compile /home/app/target/fatjar-0.0.1-SNAPSHOT.jar /usr/local/lib/opencvapp.jar

# update libs links
#RUN ldconfig /usr/local/lib

# the command that'll be used when the image will be launched
# using docker run myapp...
#ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["java", "-Djava.library.path=lib/opencv_java3410.jar", "-jar", "usr/local/lib/opencvapp.jar"]

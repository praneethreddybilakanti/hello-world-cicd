FROM openjdk:11 
#EXPOSE 8090
MAINTAINER name
#WORKDIR /app
#COPY . . 
#FROM maven:3.3.9-jdk-8-alpine
#WORKDIR /app

#RUN mvn clean package 
ADD  /target/hello-world-cicd-latest*.jar hello-world-cicd-latest.jar 
ENTRYPOINT ["java", "-jar", "hello-world-cicd-latest.jar"]

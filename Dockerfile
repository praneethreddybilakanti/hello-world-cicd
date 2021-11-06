FROM openjdk:8-jdk-alpine
EXPOSE 8090
ADD /target/hello-world-cicd-latest*.jar hello-world-cicd-latest.jar
ENTRYPOINT ["java", "-jar", "hello-world-cicd-latest.jar"]

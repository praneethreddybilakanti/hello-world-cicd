FROM openjdk:11-jdk-alpine as base 
#EXPOSE 8090
WORKDIR /app
COPY . . 
RUN ./mvn build 
COPY --from=base /app/arget/hello-world-cicd-latest*.jar hello-world-cicd-latest.jar 
ENTRYPOINT ["java", "-jar", "hello-world-cicd-latest.jar"]




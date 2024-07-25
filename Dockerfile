FROM eclipse-temurin:11-jdk-alpine
WORKDIR /app
COPY . /app
RUN apk add --no-cache maven
RUN mvn clean install
CMD ["java", "-jar", "target/demo-0.0.1-SNAPSHOT.jar"]
EXPOSE 8088

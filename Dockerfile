# Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
COPY WebContent ./WebContent
RUN mvn clean package -DskipTests

# Run stage
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# Copy WAR and webapp-runner jar
COPY --from=build /app/target/onlinebookstore.war app.war
COPY --from=build /app/target/dependency/webapp-runner.jar webapp-runner.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "webapp-runner.jar", "--port", "8080", "app.war"]

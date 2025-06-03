# Stage 1: Build the application
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY --from=build /app/target/onlinebookstore-*.jar app.jar
EXPOSE 8080
<<<<<<< HEAD
ENTRYPOINT ["java", "-jar", "app.jar"]
=======
ENTRYPOINT ["java", "-jar", "app.jar"]
>>>>>>> 3847c5e834c3f29bb731f6e5280195ca72def829

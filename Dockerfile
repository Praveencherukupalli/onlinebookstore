# Use Java 21 base image
FROM openjdk:21-jdk-slim

# Copy the JAR file into the container
COPY target/*.jar app.jar
COPY target/onlinebookstore-1.0.jar app.jar


# Expose port your app listens on (change if needed)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "/app.jar"]

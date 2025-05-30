# Use Java 21 base image
FROM openjdk:21-jdk-slim

# Copy the JAR file into the container
COPY target/*.jar app.jar

# Expose port if your Java app runs on a specific one (optional, e.g., 8080)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "/app.jar"]

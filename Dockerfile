# Use an official OpenJDK runtime as a parent image
FROM openjdk:22-jdk

# Set the working directory
WORKDIR /app

# Define a build-time variable for the JAR file name
ARG JAR_FILE

# Copy the project’s jar file into the container at /app
COPY ${JAR_FILE} app.jar

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the jar file
ENTRYPOINT ["java", "-jar", "app.jar"]
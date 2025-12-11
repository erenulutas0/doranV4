# Multi-stage build for Notification Service
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy parent pom.xml first
COPY pom.xml /app/pom.xml

# Copy service-specific files
COPY notification-service/pom.xml /app/notification-service/
COPY notification-service/src /app/notification-service/src

# Build the application
WORKDIR /app/notification-service
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Healthchecks use curl/wget inside the container
RUN apk add --no-cache curl wget

# Copy the built JAR
COPY --from=build /app/notification-service/target/*.jar app.jar

# Expose port
EXPOSE 8085

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]


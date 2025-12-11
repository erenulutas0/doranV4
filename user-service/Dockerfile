# Multi-stage build for User Service
# Stage 1: Build
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy parent pom.xml first
COPY pom.xml /app/pom.xml

# Copy service-specific files
COPY user-service/pom.xml /app/user-service/
COPY user-service/src /app/user-service/src

# Build the application
WORKDIR /app/user-service
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Healthchecks use curl/wget inside the container
RUN apk add --no-cache curl wget

# Copy the built JAR
COPY --from=build /app/user-service/target/*.jar app.jar

# Expose port
EXPOSE 8081

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]


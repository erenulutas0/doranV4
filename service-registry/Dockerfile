# Multi-stage build for Service Registry (Eureka)
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy parent pom.xml first
COPY pom.xml /app/pom.xml

# Copy service-specific files
COPY service-registry/pom.xml /app/service-registry/
COPY service-registry/src /app/service-registry/src

# Build the application
WORKDIR /app/service-registry
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy the built JAR
COPY --from=build /app/service-registry/target/*.jar app.jar

# Expose port
EXPOSE 8761

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]


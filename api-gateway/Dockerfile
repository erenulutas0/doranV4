# Multi-stage build for API Gateway
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy parent pom.xml first
COPY pom.xml /app/pom.xml

# Copy service-specific files
COPY api-gateway/pom.xml /app/api-gateway/
COPY api-gateway/src /app/api-gateway/src

# Build the application
WORKDIR /app/api-gateway
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy the built JAR
COPY --from=build /app/api-gateway/target/*.jar app.jar

# Expose port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]


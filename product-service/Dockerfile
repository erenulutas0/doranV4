# Multi-stage build for Product Service
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy parent pom.xml first
COPY pom.xml /app/pom.xml

# Copy service-specific files
COPY product-service/pom.xml /app/product-service/
COPY product-service/src /app/product-service/src

# Build the application
WORKDIR /app/product-service
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy the built JAR
COPY --from=build /app/product-service/target/*.jar app.jar

# Expose port
EXPOSE 8082

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]


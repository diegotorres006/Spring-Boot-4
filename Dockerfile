# Stage 1: Build (Actualizado a Gradle 8.14 para compatibilidad con Spring Boot 4.0.1)
FROM gradle:8.14-jdk17 AS build
WORKDIR /app

# El resto del archivo se mantiene igual
COPY build.gradle settings.gradle ./
COPY gradle ./gradle
RUN gradle dependencies --no-daemon

COPY src ./src
RUN gradle bootJar --no-daemon

# Stage 2: Runtime
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
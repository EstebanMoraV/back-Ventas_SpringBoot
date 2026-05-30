# ETAPA 1: Construcción (Maven)
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# ETAPA 2: Ejecución (Runtime ligero)
FROM openjdk:17-jdk-slim
WORKDIR /app

# SEGURIDAD: Usuario no root (IE1)
RUN groupadd -r devopsgroup && useradd -r -g devopsgroup devopsuser
USER devopsuser

# Copiamos el .jar generado en la etapa anterior
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

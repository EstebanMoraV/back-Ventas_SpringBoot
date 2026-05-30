# ETAPA 1: Construcción (Maven)
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# ETAPA 2: Ejecución (Cambiamos openjdk por amazoncorretto)
FROM amazoncorretto:17-al2-generic
WORKDIR /app

# SEGURIDAD: Usuario no root
RUN yum install -y shadow-utils && groupadd -r devopsgroup && useradd -r -g devopsgroup devopsuser
USER devopsuser

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

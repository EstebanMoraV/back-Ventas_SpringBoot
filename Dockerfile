# ETAPA 1: Instalación de dependencias
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# ETAPA 2: Ejecución segura
FROM node:18-alpine
WORKDIR /app

# SEGURIDAD: Creamos un usuario para no correr como root (Requisito IE1)
RUN addgroup -S devopsgroup && adduser -S devopsuser -G devopsgroup
USER devopsuser

# Copiamos solo lo necesario de la etapa anterior
COPY --from=builder /app .

EXPOSE 3001
CMD ["npm", "start"]

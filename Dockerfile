# Etapa 1: Build de Angular
FROM node:20 AS build

# Definir directorio de trabajo
WORKDIR /app

# Copiar package.json y package-lock.json primero para aprovechar cache
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar todo el código del proyecto
COPY . .

# Generar build de producción
RUN npm run build -- --configuration production

# Etapa 2: Servir con Nginx
FROM nginx:latest

# Copiar el build de Angular desde la etapa anterior a la carpeta de Nginx
COPY --from=build /app/dist/frontend-ferreteria /usr/share/nginx/html

# Copiar configuración personalizada de Nginx (opcional)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponer puerto 80
EXPOSE 80

# Comando por defecto para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]

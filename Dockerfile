# ==========================================
# ETAPA 1: Construcción del Frontend
# ==========================================
FROM node:18-alpine AS builder

WORKDIR /app

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar dependencias de Node
RUN npm install

# Copiar todo el código del front
COPY . .

# Compilar la aplicación para producción (genera la carpeta dist/ o build/)
RUN npm run build

# ==========================================
# ETAPA 2: Servidor de Producción Ligero
# ==========================================
FROM nginx:alpine

# Aplicar Mínimo Privilegio en las carpetas de Nginx
RUN chown -R nginx:nginx /usr/share/nginx/html /var/cache/nginx /var/run /var/log/nginx

# Copiar los archivos compilados desde la etapa anterior al directorio de Nginx
# NOTA: Cambia "dist" por "build" si tu proyecto genera una carpeta llamada build al compilar
COPY --from=builder /app/dist /usr/share/nginx/html

# Cambiar al usuario no-root que incluye por defecto la imagen de nginx
USER nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
# ===== Stage 1: Build =====
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build -- --configuration production

# ===== Stage 2: Runtime =====
FROM nginx:alpine
# Copier le build Angular dans le dossier HTML de Nginx
COPY --from=builder /app/dist/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

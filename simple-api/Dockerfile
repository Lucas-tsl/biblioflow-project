# Étape 1 : choisir une image de base
FROM node:18-alpine

# Étape 2 : définir le répertoire de travail
WORKDIR /app

# Étape 3 : copier les fichiers nécessaires
COPY package*.json ./
RUN npm install

COPY . .

# Étape 4 : exposer le port et lancer l’app
EXPOSE 3000
CMD ["node", "app.js"]

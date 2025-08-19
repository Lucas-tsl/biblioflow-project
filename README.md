# BiblioFlow — Application Full-Stack (Angular + NestJS + Docker)

Application complète **BiblioFlow** développée dans le cadre de la formation « Introduction à Docker & Conteneurisation ». Cette application comprend un frontend Angular, un backend NestJS avec gestion des livres, et une stack complète avec base de données.

---

## 🏗️ Architecture

```
biblioflow-project/
├── biblioflow/
│   ├── biblioflow-frontend/    # Application Angular
│   └── biblioflow-backend/     # API NestJS
├── docker/
│   ├── docker-compose.yml     # Orchestration complète
│   ├── .env                   # Variables d'environnement
│   ├── nginx/                 # Configuration reverse proxy
│   ├── postgres/              # Scripts d'initialisation PostgreSQL
│   └── mongodb/               # Scripts d'initialisation MongoDB
└── simple-api/               # API simple (exemple)
```

---

## 🚀 Fonctionnalités

- **Backend NestJS** : API REST complète avec authentification JWT
- **Frontend Angular** : Interface utilisateur moderne avec Angular 20+
- **PostgreSQL** : Base de données principale avec persistance des données
- **MongoDB** : Base de données pour les logs et données non-relationnelles
- **Nginx** : Reverse proxy pour routage frontend/API
- **Docker Compose** : Orchestration complète avec 5 services
- **Volumes persistants** : Données sauvegardées entre redémarrages

---

## 🧰 Prérequis

- **Node.js ≥ 20** et **npm**
- **Docker** pour la conteneurisation
- **Git** pour le versioning

---

## ⚡ Démarrage rapide

### 🐳 Avec Docker Compose (Recommandé)
```bash
# 1. Cloner le projet
git clone https://github.com/Lucas-tsl/biblioflow-project.git
cd biblioflow-project/docker

# 2. Démarrer la stack complète
docker compose --env-file ./.env up -d --build

# 3. Accéder à l'application
# Frontend: http://localhost
# API: http://localhost/api
```

### 📊 Services disponibles
- **Frontend Angular** : http://localhost (via Nginx)
- **API NestJS** : http://localhost/api (via Nginx proxy)
- **PostgreSQL** : Port 5432 (interne)
- **MongoDB** : Port 27017 (interne)
- **Nginx** : Port 80 (reverse proxy)

### 🔍 Vérification du déploiement
```bash
# Vérifier l'état des conteneurs
docker compose ps

# Surveiller les logs
docker compose logs -f api frontend

# Tester l'API
curl http://localhost/api/health
```

---

### 🛠️ Développement local (sans Docker)

### 1. Backend (NestJS)
```bash
cd biblioflow/biblioflow-backend
npm install
npm run start:dev
# → http://localhost:8080
```

### 2. Frontend (Angular)
```bash
cd biblioflow/biblioflow-frontend
npm install
npm start
# → http://localhost:4200
```

---

## 🐳 Docker

### Architecture Docker Compose

La stack complète comprend 5 services orchestrés :

```yaml
# docker-compose.yml
services:
  postgres:     # Base de données principale
  mongodb:      # Base de données logs
  api:          # Backend NestJS
  frontend:     # Frontend Angular
  nginx:        # Reverse proxy
```

### Commandes Docker utiles
```bash
# Démarrer la stack
docker compose up -d --build

# Arrêter la stack
docker compose down

# Voir les logs
docker compose logs -f [service]

# Reconstruire un service
docker compose build [service] --no-cache

# Accéder à un conteneur
docker compose exec postgres psql -U biblio -d biblioflow
docker compose exec mongodb mongosh
```

### Images individuelles

#### Backend
```bash
cd biblioflow/biblioflow-backend
docker build -t biblioflow-api .
docker run --rm -p 8080:8080 -e PORT=8080 -e JWT_SECRET=secret biblioflow-api
```

#### Frontend
```bash
cd biblioflow/biblioflow-frontend
docker build -t biblioflow-ui .
docker run --rm -p 4200:80 biblioflow-ui
```

---

## 📚 API Endpoints

**Base URL:** `http://localhost/api` (via Nginx) ou `http://localhost:8080` (direct)

### Authentification
- `POST /auth/login` - Connexion utilisateur
- `POST /auth/register` - Inscription utilisateur
- `GET /auth/profile` - Profil utilisateur (JWT requis)

### Gestion des livres
- `GET /books` - Lister tous les livres
- `POST /books` - Créer un livre
- `GET /books/:id` - Récupérer un livre
- `PUT /books/:id` - Mettre à jour un livre
- `DELETE /books/:id` - Supprimer un livre

### Santé de l'API
- `GET /health` - Vérifier l'état de l'API

### Exemple d'utilisation
```bash
# Vérifier l'état de l'API
curl http://localhost/api/health

# Lister les livres
curl http://localhost/api/books

# Créer un livre (avec authentification)
curl -X POST http://localhost/api/books \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{"title":"Clean Code","author":"Robert C. Martin"}'
```

---

## 🔧 Configuration

### Variables d'environnement (.env)
```env
# Base de données PostgreSQL
POSTGRES_DB=biblioflow
POSTGRES_USER=biblio
POSTGRES_PASSWORD=biblioflow

# MongoDB
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=adminpass
MONGO_DB=biblioflow_logs

# Backend API
BACKEND_PORT=8080
JWT_SECRET=your-super-secret-jwt-key
DATABASE_URL=postgresql://biblio:biblioflow@postgres:5432/biblioflow
MONGODB_URL=mongodb://admin:adminpass@mongodb:27017/biblioflow_logs?authSource=admin
CORS_ORIGIN=http://localhost
```

### Configuration Nginx
```nginx
# nginx/nginx.conf
upstream frontend {
    server frontend:80;
}

upstream api {
    server api:8080;
}

server {
    listen 80;
    
    location / {
        proxy_pass http://frontend;
    }
    
    location /api/ {
        proxy_pass http://api/;
    }
}
```

### Persistance des données
- **PostgreSQL** : Volume `pgdata` monté sur `/var/lib/postgresql/data`
- **MongoDB** : Volume `mongodata` monté sur `/data/db`
- **Scripts d'init** : Exécutés au premier démarrage des bases de données

---

## 🩺 Dépannage

### Docker Compose
```bash
# Problème de build
docker compose build --no-cache

# Problème de réseau
docker compose down && docker compose up -d

# Vérifier les logs d'erreur
docker compose logs [service]

# Nettoyer les volumes (⚠️ supprime les données)
docker compose down -v
```

### Bases de données
```bash
# Accéder à PostgreSQL
docker compose exec postgres psql -U biblio -d biblioflow

# Accéder à MongoDB
docker compose exec mongodb mongosh -u admin -p adminpass

# Vérifier l'état des health checks
docker compose ps
```

### Développement
- **Port occupé** : Utilisez `--port 4201` pour Angular ou changez `PORT` pour le backend
- **Erreur npm** : `rm -rf node_modules package-lock.json && npm install`
- **Problème CORS** : Vérifiez la configuration `CORS_ORIGIN` dans l'API

### Logs et monitoring
```bash
# Logs en temps réel
docker compose logs -f

# Logs d'un service spécifique
docker compose logs -f api

# Surveillance des ressources
docker stats
```

---

## 🔜 Évolutions prévues

- [x] Docker Compose pour orchestrer l'ensemble
- [x] Base de données PostgreSQL avec persistance
- [x] MongoDB pour les logs
- [x] Reverse proxy Nginx
- [x] Health checks et dépendances entre services
- [ ] Tests e2e avec Cypress
- [ ] CI/CD avec GitHub Actions
- [ ] Monitoring avec Prometheus/Grafana
- [ ] Sécurisation HTTPS avec certificats SSL

---

## 📝 Licence

Projet développé dans un cadre pédagogique.

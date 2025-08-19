# Guide de Développement BiblioFlow

## 🚀 Environnement de Développement

### Démarrage Rapide
```bash
# Aller dans le dossier docker
cd docker

# Utiliser le script de développement
./dev.sh start
```

### Services Disponibles en Mode Dev

| Service | URL Local | Port Direct | Description |
|---------|-----------|-------------|-------------|
| **Frontend** | http://localhost | http://localhost:4200 | Angular avec hot reload |
| **API** | http://localhost/api | http://localhost:8080 | NestJS avec debugging |
| **PostgreSQL** | - | localhost:5432 | Base de données principale |
| **MongoDB** | - | localhost:27017 | Base de données logs |

### Commandes de Développement

```bash
# Démarrer l'environnement
./dev.sh start

# Voir les logs en temps réel
./dev.sh logs

# Accéder au shell du backend
./dev.sh shell-api

# Accéder au shell du frontend
./dev.sh shell-frontend

# Se connecter à PostgreSQL
./dev.sh db-postgres

# Se connecter à MongoDB
./dev.sh db-mongo

# Lancer les tests
./dev.sh test

# Arrêter l'environnement
./dev.sh stop

# Nettoyer complètement (⚠️ supprime les données)
./dev.sh clean
```

## 🔧 Hot Reload

### Backend NestJS
- **Mode watch** : Le code TypeScript est recompilé automatiquement
- **Debug port** : 9229 exposé pour VSCode
- **Volumes** : Code source monté en lecture seule

### Frontend Angular
- **Live reload** : Changements CSS/HTML instantanés
- **TypeScript compilation** : Recompilation automatique
- **WebSocket** : Support du hot reload via Nginx

## 🐛 Debugging avec VSCode

### Configuration automatique
Le fichier `.vscode/launch.json` est configuré avec :

1. **Debug API (Docker)** : Attach au port 9229
2. **Debug Frontend (Chrome)** : Lance Chrome avec source maps
3. **Debug Full Stack** : Les deux en même temps

### Utilisation
1. Démarrer l'environnement de dev : `./dev.sh start`
2. Dans VSCode : `F5` → Choisir "Debug Full Stack"
3. Placer des breakpoints dans le code
4. Les breakpoints se déclenchent automatiquement

## 📊 Monitoring et Métriques

### Resource Limits Configurés

| Service | CPU Max | RAM Max | CPU Réservé | RAM Réservé |
|---------|---------|---------|-------------|-------------|
| **API** | 0.5 core | 512MB | 0.25 core | 256MB |
| **Frontend** | 0.25 core | 256MB | 0.1 core | 128MB |
| **Nginx** | 0.25 core | 128MB | 0.1 core | 64MB |

### Healthchecks
- **PostgreSQL** : `pg_isready` toutes les 5s
- **MongoDB** : `db.runCommand({ ping: 1 })` toutes les 5s  
- **Nginx** : `wget /healthz` toutes les 30s

### Logs Centralisés
- **Format** : JSON avec rotation automatique
- **Taille max** : 10MB par fichier
- **Rétention** : 3 fichiers par service
- **Accès** : `./dev.sh logs`

## 🔄 Workflow de Développement

### 1. Développement Local
```bash
# Cloner et setup
git clone https://github.com/Lucas-tsl/biblioflow-project.git
cd biblioflow-project/docker

# Démarrer en mode développement
./dev.sh start

# Développer avec hot reload
# Les changements sont visibles immédiatement
```

### 2. Tests et Debug
```bash
# Lancer les tests
./dev.sh test

# Debug avec VSCode
# F5 → "Debug Full Stack"

# Accéder aux bases de données
./dev.sh db-postgres
./dev.sh db-mongo
```

### 3. Production
```bash
# Basculer en mode production
docker compose --env-file ./.env up -d --build

# Monitoring
docker compose ps
docker compose logs -f
```

## 🛠️ Customisation

### Variables d'Environnement Dev
Créer un fichier `.env.dev` pour surcharger les variables de développement :

```env
# Base de données de dev (optionnel)
POSTGRES_DB=biblioflow_dev
MONGO_DB=biblioflow_logs_dev

# Debugging
NODE_ENV=development
DEBUG=*

# API spécifique dev
CORS_ORIGIN=http://localhost:4200
```

### Ajout de Services
Pour ajouter un service (Redis, Elasticsearch...) :

1. Ajouter dans `docker-compose.dev.yml`
2. Configurer les réseaux appropriés
3. Ajouter les variables d'environnement
4. Mettre à jour `dev.sh` si nécessaire

## 🚨 Troubleshooting

### Problèmes Courants

**Port 4200 occupé**
```bash
./dev.sh stop
lsof -ti:4200 | xargs kill -9
./dev.sh start
```

**Hot reload ne fonctionne pas**
```bash
# Vérifier les volumes
docker compose -f docker-compose.dev.yml exec frontend ls -la /app/src

# Rebuilder si nécessaire
./dev.sh build
```

**Debug VSCode ne se connecte pas**
```bash
# Vérifier que le port 9229 est exposé
docker compose -f docker-compose.dev.yml port api 9229
```

**Base de données corrompue**
```bash
# Nettoyer et recommencer
./dev.sh clean
./dev.sh start
```

## 📚 Ressources

- [Docker Compose Dev Guide](https://docs.docker.com/compose/gettingstarted/)
- [Angular CLI Development](https://angular.io/cli)
- [NestJS Hot Reload](https://docs.nestjs.com/)
- [VSCode Docker Debugging](https://code.visualstudio.com/docs/containers/debug-common)

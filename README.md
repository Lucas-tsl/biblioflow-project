# BiblioFlow — Application Full-Stack (Angular + NestJS + Docker)

Application complète **BiblioFlow** avec frontend Angular, backend NestJS et orchestration Docker.

---

## 🚀 Démarrage rapide

### 🐳 Avec Docker Compose (Recommandé)
```bash
git clone https://github.com/Lucas-tsl/biblioflow-project.git
cd biblioflow-project/docker
docker compose --env-file ./.env up -d --build
```

**Accès :** http://localhost (Frontend + API via Nginx)

---

## 🏗️ Architecture

- **Frontend Angular** : Interface utilisateur moderne
- **Backend NestJS** : API REST avec authentification JWT
- **PostgreSQL** : Base de données principale (persistante)
- **MongoDB** : Base de données logs
- **Nginx** : Reverse proxy

---

## 📚 API Endpoints

**Base :** `http://localhost/api`

- `GET /books` - Lister les livres
- `POST /books` - Créer un livre
- `GET /health` - État de l'API

---

## 🛠️ Développement local

```bash
# Backend
cd biblioflow/biblioflow-backend
npm install && npm run start:dev  # → :8080

# Frontend  
cd biblioflow/biblioflow-frontend
npm install && npm start  # → :4200
```

---

## 🔧 Docker

```bash
# Gérer la stack
docker compose ps              # État des services
docker compose logs -f api     # Logs en temps réel
docker compose down            # Arrêter

# Accès aux bases
docker compose exec postgres psql -U biblio -d biblioflow
docker compose exec mongodb mongosh -u admin -p adminpass
```

---

**Stack :** PostgreSQL + MongoDB + NestJS + Angular + Nginx  
**Fonctionnalités :** Health checks, volumes persistants, orchestration complète

# BiblioFlow — Application Full-Stack (Angular + NestJS + Docker)

Application complète **BiblioFlow** développée dans le cadre de la formation « Introduction à Docker & Conteneurisation ». Cette application comprend un frontend Angular et un backend NestJS avec gestion des livres.

---

## 🏗️ Architecture

```
biblioflow/
├── biblioflow-frontend/    # Application Angular
├── biblioflow-backend/     # API NestJS
└── simple-api/            # API simple (exemple)
```

---

## 🚀 Fonctionnalités

- **Backend NestJS** : API REST complète pour la gestion des livres (CRUD)
- **Frontend Angular** : Interface utilisateur moderne avec Angular 20+
- **Docker** : Images multi-stage optimisées pour la production
- **Ports** : Backend (8080), Frontend (4200)

---

## 🧰 Prérequis

- **Node.js ≥ 20** et **npm**
- **Docker** pour la conteneurisation
- **Git** pour le versioning

---

## ⚡ Démarrage rapide

### 1. Cloner le projet
```bash
git clone https://github.com/Lucas-tsl/biblioflow-project.git
cd biblioflow-project
```

### 2. Backend (NestJS)
```bash
cd biblioflow/biblioflow-backend
npm install
npm run start:dev
# → http://localhost:8080
```

### 3. Frontend (Angular)
```bash
cd biblioflow/biblioflow-frontend
npm install
npm start
# → http://localhost:4200
```

---

## 🐳 Docker

### Backend
```bash
cd biblioflow/biblioflow-backend
docker build -t biblioflow-api .
docker run --rm -p 8080:8080 -e PORT=8080 -e JWT_SECRET=secret biblioflow-api
```

### Frontend
```bash
cd biblioflow/biblioflow-frontend
docker build -t biblioflow-ui .
docker run --rm -p 4200:80 biblioflow-ui
```

---

## 📚 API Endpoints

**Base URL:** `http://localhost:8080`

- `GET /books` - Lister tous les livres
- `POST /books` - Créer un livre
- `GET /books/:id` - Récupérer un livre
- `PUT /books/:id` - Mettre à jour un livre
- `DELETE /books/:id` - Supprimer un livre

### Exemple d'utilisation
```bash
# Lister les livres
curl http://localhost:8080/books

# Créer un livre
curl -X POST http://localhost:8080/books \
  -H "Content-Type: application/json" \
  -d '{"title":"Clean Code","author":"Robert C. Martin"}'
```

---

## 🔧 Configuration

### Backend (.env)
```env
PORT=8080
JWT_SECRET=your-secret-key
```

### CORS (pour intégration frontend)
```typescript
// src/main.ts
app.enableCors({
  origin: 'http://localhost:4200'
});
```

---

## 🩺 Dépannage

- **Port occupé** : Utilisez `--port 4201` pour Angular ou changez `PORT` pour le backend
- **Erreur npm** : `rm -rf node_modules package-lock.json && npm install`
- **Docker** : `docker build --no-cache -t <image-name> .`

---

## 🔜 Évolutions prévues

- [ ] Docker Compose pour orchestrer l'ensemble
- [ ] Base de données PostgreSQL
- [ ] Tests e2e avec Cypress
- [ ] CI/CD avec GitHub Actions

---

## 📝 Licence

Projet développé dans un cadre pédagogique.

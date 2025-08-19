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

### Backend (NestJS)
- **API REST** complète pour la gestion des livres
- Endpoints : `GET`, `POST`, `PUT`, `DELETE` pour `/books`
- Port configurable (par défaut **8080**)
- Stockage en mémoire pour le TP
- Image Docker multi-stage optimisée

### Frontend (Angular)
- Interface utilisateur moderne avec Angular 20+
- Gestion des livres (CRUD)
- Communication avec l'API backend
- Serveur de développement sur port **4200** (ou 4201 si occupé)

---

## 🧰 Prérequis

- **Node.js ≥ 20** (recommandé)
- **npm** pour la gestion des dépendances
- **Docker** pour la conteneurisation
- **Git** pour le versioning

---

## ⚡ Démarrage rapide

### 1. Cloner le projet
```bash
git clone <votre-repo-url>
cd <nom-du-projet>
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

### Backend avec Docker
```bash
cd biblioflow/biblioflow-backend

# Build de l'image
docker build -t biblioflow-api .

# Lancement du conteneur
docker run --rm -p 8080:8080 \
  -e PORT=8080 -e JWT_SECRET=secret \
  biblioflow-api
```

### Frontend avec Docker
```bash
cd biblioflow/biblioflow-frontend

# Build de l'image
docker build -t biblioflow-ui .

# Lancement du conteneur
docker run --rm -p 4200:80 biblioflow-ui
```

---

## 📚 API Documentation

### Base URL
```
http://localhost:8080
```

### Endpoints disponibles

#### 1. Lister tous les livres
```bash
GET /books
curl http://localhost:8080/books
```

#### 2. Créer un livre
```bash
POST /books
curl -X POST http://localhost:8080/books \
  -H "Content-Type: application/json" \
  -d '{"title":"Clean Code","author":"Robert C. Martin"}'
```

#### 3. Récupérer un livre par ID
```bash
GET /books/:id
curl http://localhost:8080/books/<id>
```

#### 4. Mettre à jour un livre
```bash
PUT /books/:id
curl -X PUT http://localhost:8080/books/<id> \
  -H "Content-Type: application/json" \
  -d '{"title":"Clean Code (Updated)"}'
```

#### 5. Supprimer un livre
```bash
DELETE /books/:id
curl -X DELETE http://localhost:8080/books/<id>
```

---

## 🔧 Configuration

### Variables d'environnement (Backend)
Créer un fichier `.env` dans `biblioflow-backend/` :

```env
PORT=8080
JWT_SECRET=your-secret-key
```

### Configuration CORS (Intégration Front/Back)

#### Option A : Activer CORS dans NestJS
```typescript
// src/main.ts
app.enableCors({
  origin: 'http://localhost:4200',
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
  allowedHeaders: 'Content-Type, Authorization',
});
```

#### Option B : Proxy Angular (Recommandé)
Créer `proxy.conf.json` dans le frontend :
```json
{
  "/api": {
    "target": "http://localhost:8080",
    "secure": false,
    "changeOrigin": true,
    "logLevel": "debug",
    "pathRewrite": { "^/api": "" }
  }
}
```

Lancer Angular avec le proxy :
```bash
ng serve --proxy-config proxy.conf.json
```

---

## 🌐 URLs de développement

- **Backend API** : http://localhost:8080
- **Frontend Angular** : http://localhost:4200
- **API Documentation** : http://localhost:8080/books

---

## 🛠️ Développement

### Structure du projet
```
biblioflow/
├── biblioflow-frontend/
│   ├── src/
│   ├── package.json
│   ├── angular.json
│   └── Dockerfile
├── biblioflow-backend/
│   ├── src/
│   ├── package.json
│   ├── nest-cli.json
│   └── Dockerfile
└── README.md
```

### Scripts utiles

#### Backend
```bash
npm run start:dev    # Développement avec watch
npm run build        # Build de production
npm run test         # Tests unitaires
```

#### Frontend
```bash
npm start            # Serveur de développement
npm run build        # Build de production
npm test            # Tests unitaires
```

---

## 🩺 Dépannage

### Problèmes courants

#### Port déjà utilisé
- **Backend** : Changez `PORT` dans `.env` ou utilisez `PORT=8081 npm run start:dev`
- **Frontend** : Utilisez `ng serve --port 4201`

#### Erreur de modules npm
```bash
rm -rf node_modules package-lock.json
npm install
```

#### Problème Docker
```bash
# Rebuild sans cache
docker build --no-cache --pull -t biblioflow-api .
```

#### Erreur Angular CLI
```bash
# Réinstaller Angular CLI
npm install -g @angular/cli@latest
```

---

## ✅ Bonnes pratiques appliquées

- **Multi-stage Docker builds** pour des images optimisées
- **Variables d'environnement** pour la configuration
- **CORS** configuré pour l'intégration front/back
- **TypeScript** pour un code type-safe
- **Modules ES** et architecture modulaire
- **Docker ignore** pour des builds rapides

---

## 🔜 Évolutions prévues

- [ ] **Docker Compose** pour orchestrer l'ensemble
- [ ] **Base de données PostgreSQL** avec volumes persistants
- [ ] **Tests e2e** avec Cypress
- [ ] **CI/CD** avec GitHub Actions
- [ ] **Monitoring** et logs centralisés

---

## 📝 Licence

Ce projet est développé dans un cadre pédagogique.

---

## 🤝 Contribution

1. Fork le projet
2. Créez votre branche (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Committez vos changements (`git commit -m 'Ajout nouvelle fonctionnalité'`)
4. Poussez vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Ouvrez une Pull Request

---

## 🆘 Support

Pour toute question ou problème :
- Ouvrez une **issue** sur GitHub
- Consultez la documentation dans chaque sous-projet
- Vérifiez les logs Docker/npm en cas d'erreur

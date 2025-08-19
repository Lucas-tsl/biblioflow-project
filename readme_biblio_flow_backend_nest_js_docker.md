# BiblioFlow — Backend (NestJS + Docker) — Ports & intégration Angular

Backend minimal pour **BiblioFlow**, utilisé dans la formation « Introduction à Docker & Conteneurisation ». Ce service expose un CRUD **Books** via NestJS et une image Docker multi‑stage (Node 22).

---

## 🚀 Fonctionnalités
- Endpoints REST **/books** : `GET /`, `POST /`, `GET /:id`, `PUT /:id`, `DELETE /:id` (stockage en mémoire pour le TP).
- Port **8080** (configurable par variable d’environnement `PORT`).
- Image Docker **multi-stage** (builder → runtime) pour une image de prod **légère**.

---

## 🧰 Prérequis
- **Node.js ≥ 20** (recommandé) et **npm** pour le développement local.
- **Docker** pour l’exécution conteneurisée.

---

## ⚙️ Configuration (env)
Créer un fichier `.env` (non versionné) à la racine du backend :

```env
PORT=8080
JWT_SECRET=change-me
```

Fichier d’exemple fourni : `.env.example`.

---

## 🏃‍♂️ Démarrage (développement local)
```bash
npm install
npm run start:dev
# → http://localhost:8080
```
> Si besoin d’appeler l’API depuis un front sur un autre port, activez CORS dans `main.ts` (ex. `app.enableCors()`).

---

## 🐳 Docker
### Dockerfile (extrait)
Multi‑stage avec Node 22 :
```dockerfile
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:22-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY package*.json ./
RUN npm ci --only=production
COPY --from=builder /app/dist ./dist
EXPOSE 8080
CMD ["node", "dist/main.js"]
```

### Build & Run
```bash
# Build
docker build -t biblioflow-api .

# Run (port + variables d’env)
docker run --rm -p 8080:8080 \
  -e PORT=8080 -e JWT_SECRET=secret \
  biblioflow-api
# → http://localhost:8080
```

### .dockerignore (recommandé)
```
node_modules
dist
.git
.gitignore
Dockerfile
README.md
.env
```

---

## 📚 API
Base URL : `http://localhost:8080`

### 1) Lister les livres
```bash
curl http://localhost:8080/books
```
Réponse :
```json
[]
```

### 2) Créer un livre
```bash
curl -X POST http://localhost:8080/books \
  -H "Content-Type: application/json" \
  -d '{"title":"Clean Code","author":"Robert C. Martin"}'
```
Exemple de réponse :
```json
{
  "id": "8a0e...",
  "title": "Clean Code",
  "author": "Robert C. Martin"
}
```

### 3) Récupérer un livre par id
```bash
curl http://localhost:8080/books/<id>
```

### 4) Mettre à jour un livre
```bash
curl -X PUT http://localhost:8080/books/<id> \
  -H "Content-Type: application/json" \
  -d '{"title":"Clean Code (rev)"}'
```

### 5) Supprimer un livre
```bash
curl -X DELETE http://localhost:8080/books/<id>
```

> Remplacez `<id>` par l’identifiant retourné lors de la création.

---

## ✅ Bonnes pratiques appliquées
- **Multi‑stage build** pour réduire la taille de l’image.
- `npm ci` pour des installations déterministes.
- Variables d’environnement **hors** de l’image (passées au run / orchestrateur).
- `.dockerignore` pour des builds plus rapides.

---

## 🩺 Dépannage
- **Port déjà utilisé** : changez `PORT` dans `.env` et la redirection `-p host:container`.
- **Cache Docker obsolète** : `docker build --no-cache --pull -t biblioflow-api .`
- **Node local trop ancien** : utilisez Node 20+ en dev, ou passez par Docker.

---

## 🔜 Prochaines étapes (Jour 2)
- **Docker Compose** : orchestrer frontend + backend + **PostgreSQL**.
- Réseaux, variables d’environnement et **volumes** persistants.


---

## 🌐 URLs locales (actuelles)
- **Backend NestJS** : <http://localhost:8080/>
- **Frontend Angular (dev)** : <http://localhost:4200/>

## 🔗 Intégration Front/Back (CORS ou proxy)

### Option A — Activer CORS côté Nest
```ts
// src/main.ts
app.enableCors({
  origin: 'http://localhost:4200',
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
  allowedHeaders: 'Content-Type, Authorization',
});
```

### Option B — Proxy Angular (recommandé en dev)
Créer `proxy.conf.json` à la racine du frontend :
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
Configurer l’URL d’API côté Angular (ex. `environment.ts`) :
```ts
export const environment = {
  production: false,
  apiBase: '/api'
};
```

## 🧪 Appels depuis l’UI (avec proxy)
- `GET /api/books` — lister
- `POST /api/books` — créer
- `GET /api/books/:id` — lire
- `PUT /api/books/:id` — mettre à jour
- `DELETE /api/books/:id` — supprimer

> Sans proxy, remplacez `/api` par `http://localhost:8080` et gardez `app.enableCors()` côté Nest.


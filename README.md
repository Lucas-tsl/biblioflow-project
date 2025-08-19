# BiblioFlow — Application Full-Stack (Angular + NestJS + Docker)

🚀 **Application complète** avec frontend Angular, backend NestJS et orchestration Docker production-ready.

**Stack :** PostgreSQL + MongoDB + NestJS + Angular + Nginx | **Status :** ✅ Production Ready

---

## ⚡ Démarrage Rapide

```bash
git clone https://github.com/Lucas-tsl/biblioflow-project.git
cd biblioflow-project/docker
docker compose --env-file ./.env up -d --build
```

🌐 **Accès :** http://localhost | 📊 **Monitoring :** `docker compose ps`

---

## 🏗️ Architecture & Services

| Service | Rôle | Port | Status |
|---------|------|------|--------|
| **Frontend** | Angular UI | 80 (Nginx) | ✅ Hot reload |
| **API** | NestJS REST | 8080 | ✅ JWT Auth |
| **PostgreSQL** | Base principale | 5432 | ✅ Persistant |
| **MongoDB** | Logs & Audit | 27017 | ✅ Réplication |
| **Nginx** | Reverse Proxy | 80 | ✅ Load balancing |

---

## 🛠️ Commandes Essentielles

### Production
```bash
docker compose ps                    # État des services
docker compose logs -f api          # Logs temps réel
curl http://localhost/healthz        # Health check
```

### Développement
```bash
./dev.sh start                      # 🔥 Hot reload complet
./dev.sh logs                       # 📊 Logs multicouleurs
./dev.sh shell-api                  # 🐚 Shell backend
./dev.sh db-postgres                # 🗄️ PostgreSQL CLI
```

### Base de données
```bash
docker compose exec postgres psql -U biblio -d biblioflow
docker compose exec mongodb mongosh -u admin -p adminpass
```

---

## 🎯 Fonctionnalités

<table>
<tr>
<td width="50%">

**🏭 Production Ready**
- ✅ Orchestration 5 services
- ✅ Resource limits & restart policies
- ✅ Logs centralisés + rotation  
- ✅ Healthchecks automatiques
- ✅ Réseaux sécurisés

</td>
<td width="50%">

**🔧 Développement**
- ✅ Hot reload Angular + NestJS
- ✅ Scripts automatisés (`./dev.sh`)
- ✅ VSCode debugging intégré
- ✅ Bind mounts code source
- ✅ Debug ports exposés

</td>
</tr>
</table>

**API Endpoints :** `http://localhost/api` → `/books`, `/health` | **Auth :** JWT Ready

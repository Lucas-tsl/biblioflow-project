# 📚 BiblioFlow — Architecture Docker Modulaire

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Angular](https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white)](https://angular.io/)
[![NestJS](https://img.shields.io/badge/NestJS-E0234E?style=for-the-badge&logo=nestjs&logoColor=white)](https://nestjs.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)](https://postgresql.org/)

> 🚀 **Application Full-Stack moderne** avec architecture Docker Compose modulaire pour tous vos environnements de développement.

**Stack Technique :** Angular 17+ • NestJS • PostgreSQL 16 • Docker Compose

**Statut :** ✅ Production Ready • 🔄 CI/CD Ready • 🚀 Multi-Environment

---

## ⚡ Quick Start

```bash
# Clone the repository
git clone https://github.com/Lucas-tsl/biblioflow-project.git
cd biblioflow-project

# 🔧 Development with hot reload
docker compose -f compose.yml -f compose.override.dev.yml up --build

# 🧪 CI/CD Testing
docker compose -f compose.yml -f compose.ci.yml up --build

# 🚀 Production Deployment
export GIT_COMMIT=$(git rev-parse HEAD)
docker compose -f compose.yml -f compose.ci.deploy.yml up -d
```

### 🌐 Access URLs
- **Backend API:** http://localhost:8081
- **Frontend App:** http://localhost:8082
- **Health Check:** http://localhost:8081/health

---

## 🏗️ Modular Architecture

### 📂 Docker Compose Files
| File | Purpose | Environment |
|------|---------|-------------|
| `compose.yml` | Base configuration | All environments |
| `compose.override.dev.yml` | Development overrides + hot reload | Development |
| `compose.ci.yml` | CI/CD with health checks | Testing/CI |
| `compose.ci.deploy.yml` | Production with registry images | Production |

### 🐳 Services Overview
| Service | Port | Technology | Source Code |
|---------|------|------------|-------------|
| **Backend** | `8081` | NestJS + TypeScript | `./biblioflow/biblioflow-backend/` |
| **Frontend** | `8082` | Angular 17+ | `./biblioflow/biblioflow-frontend/` |
| **Database** | `5432` | PostgreSQL 16 | Official Docker image |

### 🌟 Key Features
- ✅ **Hot Reload** development environment
- ✅ **Health Checks** for all services
- ✅ **Multi-stage builds** optimized for production
- ✅ **Registry support** for CI/CD deployment
- ✅ **Environment-specific** configurations
- ✅ **Volume persistence** for database

---

## 🛠️ Development Commands

```bash
# 📊 View logs
docker compose logs -f

# 🔍 Health check
curl http://localhost:8081/health

# 🗄️ Database access
docker compose exec db psql -U myapp -d mydb

# 🧹 Stop and cleanup
docker compose down --volumes

# 🔄 Rebuild without cache
docker compose build --no-cache
```

## ⚙️ Environment Variables

```bash
# Required for all environments
DB_PASSWORD=your_secure_password    # PostgreSQL password

# Required for production deployment
GIT_COMMIT=abc123def456             # Git commit hash for image tagging
REGISTRY_URL=registry.example.com   # Docker registry URL
```

## 🚀 Deployment Environments

### 🔧 Development
- **Purpose:** Local development with hot reload
- **Features:** Live code changes, bind mounts, debug mode
- **Command:** `docker compose -f compose.yml -f compose.override.dev.yml up`

### 🧪 CI/CD
- **Purpose:** Automated testing and validation
- **Features:** Health checks, isolated builds, test environment
- **Command:** `docker compose -f compose.yml -f compose.ci.yml up`

### 🌐 Production
- **Purpose:** Production deployment with registry images
- **Features:** Optimized images, restart policies, monitoring
- **Command:** `docker compose -f compose.yml -f compose.ci.deploy.yml up -d`

## 📋 Prerequisites

- **Docker Engine** 20.10+
- **Docker Compose** v2.0+
- **Git** for cloning repository
- **Node.js** 18+ (for local development)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Made with ❤️ by [Lucas-tsl](https://github.com/Lucas-tsl)**

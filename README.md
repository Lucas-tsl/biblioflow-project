# 📚 BiblioFlow

Application Full-Stack avec Angular, NestJS et PostgreSQL.

## 🚀 Quick Start

```bash
# Développement
docker compose -f compose.yml -f compose.override.dev.yml up --build

# CI/CD
docker compose -f compose.yml -f compose.ci.yml up --build
```

## 📡 URLs
- **Backend:** http://localhost:8085
- **Frontend:** http://localhost:8084
- **Database:** PostgreSQL sur port 5432

## 🏗️ Architecture

- **Backend:** NestJS (`./biblioflow/biblioflow-backend/`)
- **Frontend:** Angular (`./biblioflow/biblioflow-frontend/`)
- **Database:** PostgreSQL 16
- **CI/CD:** Jenkins pipeline complet

## 📋 Prérequis

- Docker Engine 20.10+
- Docker Compose v2.0+

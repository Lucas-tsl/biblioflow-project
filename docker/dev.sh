#!/bin/bash

# Scripts de développement BiblioFlow
# Usage: ./dev.sh [command]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Couleurs pour l'output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonctions utilitaires
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Commandes disponibles
show_help() {
    echo "BiblioFlow - Scripts de développement"
    echo ""
    echo "Usage: ./dev.sh [command]"
    echo ""
    echo "Commandes disponibles:"
    echo "  start         Démarrer l'environnement de développement"
    echo "  stop          Arrêter l'environnement de développement"
    echo "  restart       Redémarrer l'environnement"
    echo "  logs          Afficher les logs en temps réel"
    echo "  status        Afficher le statut des services"
    echo "  clean         Nettoyer les volumes et images"
    echo "  shell-api     Accéder au shell du backend"
    echo "  shell-frontend Accéder au shell du frontend"
    echo "  db-postgres   Accéder à PostgreSQL"
    echo "  db-mongo      Accéder à MongoDB"
    echo "  test          Lancer les tests"
    echo "  build         Rebuild les images"
    echo "  help          Afficher cette aide"
}

# Démarrer l'environnement de développement
dev_start() {
    log_info "Démarrage de l'environnement de développement..."
    docker compose -f docker-compose.dev.yml --env-file ./.env up -d --build
    log_success "Environnement démarré !"
    log_info "Frontend: http://localhost:4200"
    log_info "API: http://localhost:8080"
    log_info "Nginx Proxy: http://localhost"
    log_info "Utilisez './dev.sh logs' pour voir les logs"
}

# Arrêter l'environnement
dev_stop() {
    log_info "Arrêt de l'environnement de développement..."
    docker compose -f docker-compose.dev.yml down
    log_success "Environnement arrêté !"
}

# Redémarrer
dev_restart() {
    log_info "Redémarrage de l'environnement..."
    dev_stop
    sleep 2
    dev_start
}

# Afficher les logs
dev_logs() {
    log_info "Affichage des logs en temps réel (Ctrl+C pour arrêter)..."
    docker compose -f docker-compose.dev.yml logs -f
}

# Statut des services
dev_status() {
    log_info "Statut des services:"
    docker compose -f docker-compose.dev.yml ps
}

# Nettoyer
dev_clean() {
    log_warning "Cette action va supprimer tous les volumes et images de développement."
    read -p "Êtes-vous sûr ? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Nettoyage en cours..."
        docker compose -f docker-compose.dev.yml down -v --rmi all
        docker system prune -f
        log_success "Nettoyage terminé !"
    else
        log_info "Nettoyage annulé."
    fi
}

# Accès shell backend
dev_shell_api() {
    log_info "Accès au shell du backend..."
    docker compose -f docker-compose.dev.yml exec api sh
}

# Accès shell frontend
dev_shell_frontend() {
    log_info "Accès au shell du frontend..."
    docker compose -f docker-compose.dev.yml exec frontend sh
}

# Accès PostgreSQL
dev_db_postgres() {
    log_info "Connexion à PostgreSQL..."
    docker compose -f docker-compose.dev.yml exec postgres psql -U biblio -d biblioflow
}

# Accès MongoDB
dev_db_mongo() {
    log_info "Connexion à MongoDB..."
    docker compose -f docker-compose.dev.yml exec mongodb mongosh -u admin -p adminpass
}

# Tests
dev_test() {
    log_info "Lancement des tests..."
    docker compose -f docker-compose.dev.yml exec api npm test
    docker compose -f docker-compose.dev.yml exec frontend ng test --watch=false
}

# Build
dev_build() {
    log_info "Reconstruction des images..."
    docker compose -f docker-compose.dev.yml build --no-cache
    log_success "Images reconstruites !"
}

# Traitement des arguments
case "${1:-help}" in
    start)
        dev_start
        ;;
    stop)
        dev_stop
        ;;
    restart)
        dev_restart
        ;;
    logs)
        dev_logs
        ;;
    status)
        dev_status
        ;;
    clean)
        dev_clean
        ;;
    shell-api)
        dev_shell_api
        ;;
    shell-frontend)
        dev_shell_frontend
        ;;
    db-postgres)
        dev_db_postgres
        ;;
    db-mongo)
        dev_db_mongo
        ;;
    test)
        dev_test
        ;;
    build)
        dev_build
        ;;
    help|*)
        show_help
        ;;
esac

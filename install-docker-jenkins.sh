#!/bin/bash

# Script d'installation Docker + Jenkins pour BiblioFlow
# Compatible Debian/Ubuntu

set -e

# Couleurs pour l'output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Vérification des privilèges
check_sudo() {
    if [[ $EUID -eq 0 ]]; then
        log_error "Ce script ne doit PAS être exécuté en tant que root"
        log_info "Utilisez: ./install-docker-jenkins.sh"
        exit 1
    fi
    
    if ! sudo -n true 2>/dev/null; then
        log_error "Ce script nécessite des privilèges sudo"
        exit 1
    fi
}

# Installation Docker
install_docker() {
    log_info "Installation de Docker..."
    
    # Mise à jour des packages
    sudo apt-get update
    
    # Installation Docker
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        docker.io \
        docker-compose-plugin
    
    # Démarrage et activation de Docker
    sudo systemctl start docker
    sudo systemctl enable docker
    
    log_success "Docker installé avec succès"
}

# Configuration des permissions
setup_docker_permissions() {
    log_info "Configuration des permissions Docker..."
    
    # Ajout de l'utilisateur actuel au groupe docker
    sudo usermod -aG docker $USER
    
    # Si Jenkins existe, l'ajouter aussi au groupe docker
    if id "jenkins" &>/dev/null; then
        log_info "Utilisateur Jenkins détecté, ajout au groupe docker..."
        sudo usermod -aG docker jenkins
    fi
    
    log_success "Permissions Docker configurées"
}

# Installation Jenkins (optionnel)
install_jenkins() {
    log_info "Installation de Jenkins..."
    
    # Ajout de la clé GPG Jenkins
    curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
        /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    
    # Ajout du repository Jenkins
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
        https://pkg.jenkins.io/debian binary/ | sudo tee \
        /etc/apt/sources.list.d/jenkins.list > /dev/null
    
    # Installation
    sudo apt-get update
    sudo apt-get install -y openjdk-17-jdk jenkins
    
    # Démarrage Jenkins
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    
    log_success "Jenkins installé avec succès"
    log_info "Jenkins sera accessible sur: http://localhost:8080"
}

# Redémarrage des services
restart_services() {
    log_info "Redémarrage des services..."
    
    sudo systemctl restart docker
    
    if systemctl is-active --quiet jenkins; then
        sudo systemctl restart jenkins
        log_info "Jenkins redémarré"
    fi
    
    log_success "Services redémarrés"
}

# Test de la configuration
test_installation() {
    log_info "Test de l'installation..."
    
    # Test Docker
    if docker --version >/dev/null 2>&1; then
        log_success "Docker: $(docker --version)"
    else
        log_error "Docker n'est pas accessible"
        return 1
    fi
    
    # Test Docker Compose
    if docker compose version >/dev/null 2>&1; then
        log_success "Docker Compose: $(docker compose version --short)"
    else
        log_error "Docker Compose n'est pas accessible"
        return 1
    fi
    
    # Test Jenkins (si installé)
    if systemctl is-active --quiet jenkins; then
        log_success "Jenkins: Service actif"
        log_info "Mot de passe initial: sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
    fi
}

# Affichage de l'aide
show_help() {
    echo "Script d'installation Docker + Jenkins pour BiblioFlow"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --docker-only    Installer uniquement Docker"
    echo "  --jenkins-only   Installer uniquement Jenkins (Docker requis)"
    echo "  --full          Installer Docker + Jenkins (défaut)"
    echo "  --test          Tester l'installation existante"
    echo "  --help          Afficher cette aide"
}

# Fonction principale
main() {
    case "${1:---full}" in
        --docker-only)
            check_sudo
            install_docker
            setup_docker_permissions
            restart_services
            test_installation
            log_warning "IMPORTANT: Déconnectez-vous et reconnectez-vous pour que les permissions prennent effet"
            ;;
        --jenkins-only)
            check_sudo
            install_jenkins
            setup_docker_permissions
            restart_services
            test_installation
            ;;
        --full)
            check_sudo
            install_docker
            install_jenkins
            setup_docker_permissions
            restart_services
            test_installation
            log_warning "IMPORTANT: Déconnectez-vous et reconnectez-vous pour que les permissions prennent effet"
            ;;
        --test)
            test_installation
            ;;
        --help)
            show_help
            ;;
        *)
            log_error "Option inconnue: $1"
            show_help
            exit 1
            ;;
    esac
}

# Point d'entrée
main "$@"

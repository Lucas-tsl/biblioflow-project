pipeline {
  agent any
  options {
    timestamps()
    ansiColor('xterm')
    disableConcurrentBuilds()
    timeout(time: 25, unit: 'MINUTES')
  }
  tools {
    nodejs 'Node_24'
  }
  environment {
    COMPOSE_BASE      = "compose.yml"
    COMPOSE_CI        = "compose.ci.yml"
    COMPOSE_OVERRIDE  = "compose.override.ci.yml"
    // Assure un PATH standard même en non-login shell
    PATH = "/usr/local/bin:/usr/bin:/bin:${PATH}"
    DOCKER_BUILDKIT = "1"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Diag Docker') {
      steps {
        sh '''#!/bin/bash
          set -euxo pipefail
          echo "PATH=$PATH"
          id
          which docker || true
          if command -v docker >/dev/null 2>&1; then
            ls -l "$(command -v docker)"
            file "$(command -v docker)" || true
            mount | grep -E "noexec|$(dirname "$(command -v docker)")" || true
          fi
        '''
      }
    }

    stage('Preflight') {
      steps {
        sh '''#!/bin/bash
          set -euo pipefail
          # Fichiers compose requis
          for f in "$COMPOSE_BASE" "$COMPOSE_CI" "$COMPOSE_OVERRIDE"; do
            [ -f "$f" ] || { echo "::error::$f missing"; exit 1; }
          done

          # Docker CLI présent et exécutable ?
          if ! command -v docker >/dev/null 2>&1; then
            echo "::error::docker CLI introuvable dans le PATH"
            exit 1
          fi

          # Vérifie que l'exécution n'est pas bloquée par un mount noexec
          BIN_DIR="$(dirname "$(command -v docker)")"
          if mount | grep " $BIN_DIR " | grep -q noexec; then
            echo "::error::le répertoire de docker ($BIN_DIR) est monté avec noexec"
            exit 1
          fi

          docker version

          # Détection Compose v1 vs v2
          if command -v docker-compose >/dev/null 2>&1; then
            COMPOSE_CLI="docker-compose"
          else
            COMPOSE_CLI="docker compose"
          fi
          echo "Using COMPOSE_CLI='$COMPOSE_CLI'"
          $COMPOSE_CLI version
        '''
      }
    }

    stage('Build image (frontend)') {
      steps {
        sh '''#!/bin/bash
          set -euo pipefail
          if command -v docker-compose >/dev/null 2>&1; then
            COMPOSE_CLI="docker-compose"
          else
            COMPOSE_CLI="docker compose"
          fi
          $COMPOSE_CLI -f "$COMPOSE_BASE" -f "$COMPOSE_CI" -f "$COMPOSE_OVERRIDE" \
            build frontend --pull --no-cache
        '''
      }
    }

    stage('Run (CI)') {
      steps {
        sh '''#!/bin/bash
          set -euo pipefail
          if command -v docker-compose >/dev/null 2>&1; then
            COMPOSE_CLI="docker-compose"
          else
            COMPOSE_CLI="docker compose"
          fi
          $COMPOSE_CLI -f "$COMPOSE_BASE" -f "$COMPOSE_CI" -f "$COMPOSE_OVERRIDE" down --remove-orphans || true
          $COMPOSE_CLI -f "$COMPOSE_BASE" -f "$COMPOSE_CI" -f "$COMPOSE_OVERRIDE" up -d frontend --force-recreate
        '''
      }
    }

    stage('Smoke test') {
      steps {
        retry(10) {
          sh '''#!/bin/bash
            set -euo pipefail
            if command -v docker-compose >/dev/null 2>&1; then
              COMPOSE_CLI="docker-compose"
            else
              COMPOSE_CLI="docker compose"
            fi
            curl -fsS http://localhost:8084/ > /dev/null || ($COMPOSE_CLI -f "$COMPOSE_BASE" -f "$COMPOSE_CI" -f "$COMPOSE_OVERRIDE" ps && sleep 3 && false)
          '''
        }
      }
    }
  }

  post {
    always {
      script {
        if (env.BRANCH_NAME && env.BRANCH_NAME != 'main') {
          sh '''#!/bin/bash
            set -euo pipefail
            if command -v docker-compose >/dev/null 2>&1; then
              COMPOSE_CLI="docker-compose"
            else
              COMPOSE_CLI="docker compose"
            fi
            $COMPOSE_CLI -f "$COMPOSE_BASE" -f "$COMPOSE_CI" -f "$COMPOSE_OVERRIDE" down -v || true
          '''
        }
      }
      cleanWs()
    }
    success { echo '✅ Frontend build & smoke test OK' }
    failure { echo '❌ Échec frontend – voir logs ci-dessus' }
  }
}

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
    COMPOSE_BASE = "compose.yml"
    COMPOSE_CI   = "compose.ci.yml"
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Preflight') {
      steps {
        sh '''
          set -e
          for f in "$COMPOSE_BASE" "$COMPOSE_CI"; do
            [ -f "$f" ] || { echo "::error::$f missing"; exit 1; }
          done
          docker version
          docker-compose version
        '''
      }
    }

    stage('Build image (frontend)') {
      steps {
        sh 'docker-compose -f "$COMPOSE_BASE" -f "$COMPOSE_CI" build frontend --pull --no-cache'
      }
    }

    stage('Run (CI)') {
      steps {
        sh '''
          docker-compose -f "$COMPOSE_BASE" -f "$COMPOSE_CI" down --remove-orphans || true
          docker-compose -f "$COMPOSE_BASE" -f "$COMPOSE_CI" up -d frontend --force-recreate
        '''
      }
    }

    stage('Smoke test') {
      steps {
        retry(10) {
          sh '''
            curl -fsS http://localhost:8084/ > /dev/null || (docker-compose -f "$COMPOSE_BASE" -f "$COMPOSE_CI" ps && sleep 3 && false)
          '''
        }
      }
    }
  }
  post {
    always {
      // En CI sur branches feature : on nettoie
      script {
        if (env.BRANCH_NAME && env.BRANCH_NAME != 'main') {
          sh 'docker-compose -f "$COMPOSE_BASE" -f "$COMPOSE_CI" down -v || true'
        }
      }
      cleanWs()
    }
    success { echo '✅ Frontend build & smoke test OK' }
    failure { echo '❌ Échec frontend – voir logs ci-dessus' }
  }
}

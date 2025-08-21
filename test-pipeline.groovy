pipeline {
    agent any
    stages {
        stage('Test Docker') {
            steps {
                sh 'docker --version'
                sh 'docker-compose --version'
                echo 'Docker tools are working!'
            }
        }
        stage('Test Docker Compose Config') {
            steps {
                sh 'docker-compose -f compose.yml -f compose.ci.yml -f compose.override.ci.yml config --quiet'
                echo 'Docker Compose configuration is valid!'
            }
        }
        stage('Test Container Access') {
            steps {
                sh 'docker ps'
                echo 'Can access Docker daemon!'
            }
        }
    }
}

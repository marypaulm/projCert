pipeline {
    agent { label 'php-slave' }
    environment {
        DOCKER_IMAGE = "php-webapp:${env.BRANCH_NAME}"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/edureka-devops/projCert.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'composer install'
            }
        }
        stage('Run Tests') {
            steps {
                sh 'phpunit tests'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }
        stage('Deploy to Test Server') {
            steps {
                sh '''
                    docker rm -f php-app || true
                    docker run -d --name php-app -p 80:80 $DOCKER_IMAGE
                '''
            }
        }
    }
    post {
        always {
            echo "Pipeline finished for branch ${env.BRANCH_NAME}"
        }
        failure {
            echo "Pipeline failed for branch ${env.BRANCH_NAME}"
        }
    }
}

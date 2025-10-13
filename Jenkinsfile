pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Building PHP App...'
            }
        }
        stage('Test') {
            steps {
                echo 'Running Tests...'
            }
        }
        stage('Deploy') {
            steps {
                echo "Deploying ${env.BRANCH_NAME} branch..."
            }
        }
    }
}

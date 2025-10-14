pipeline {
    agent { label 'php-slave' }

    environment {
        DOCKER_IMAGE = "php-app:${env.BRANCH_NAME}"
        REPO_URL = "https://github.com/marypaulm/projCert.git"

        ANSIBLE_INVENTORY = "/home/ubuntu/ansible/hosts"
        ANSIBLE_PLAYBOOK = "/home/ubuntu/ansible/jenkins-slave-configurations.yml"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out branch: ${env.BRANCH_NAME}"
                git branch: "${env.BRANCH_NAME}", url: "${REPO_URL}"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image from website folder..."
                sh 'sudo docker build -t $DOCKER_IMAGE ./website'
            }
        }

        stage('Test Docker Image') {
            steps {
                echo "Running test container to verify PHP..."
                sh 'sudo docker run --rm $DOCKER_IMAGE php -v'
            }
        }

        stage('Deploy via Ansible') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        echo "Deploying to DEV server"
                        sh "ansible-playbook -i $ANSIBLE_INVENTORY $ANSIBLE_PLAYBOOK --limit dev"
                    } else if (env.BRANCH_NAME == 'stage') {
                        echo "Deploying to STAGE server"
                        sh "ansible-playbook -i $ANSIBLE_INVENTORY $ANSIBLE_PLAYBOOK --limit stage"
                    } else if (env.BRANCH_NAME == 'master') {
                        echo "Deploying to PROD server"
                        sh "ansible-playbook -i $ANSIBLE_INVENTORY $ANSIBLE_PLAYBOOK --limit prod"
                    } else {
                        echo "Branch ${env.BRANCH_NAME} is not mapped to any environment. Skipping deploy."
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build, test, and deployment completed successfully on branch ${env.BRANCH_NAME}!"
        }
        failure {
            echo "❌ Pipeline failed on branch ${env.BRANCH_NAME}. Check Jenkins console for details."
        }
    }
}

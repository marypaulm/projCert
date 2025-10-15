pipeline {
    agent { label 'php-slave' }

    environment {
        DOCKER_IMAGE = "php-app:${env.BRANCH_NAME}"
        REPO_URL = "https://github.com/marypaulm/projCert.git"

        ANSIBLE_INVENTORY = "/home/ubuntu/ansible/hosts"
        ANSIBLE_PLAYBOOK = "/home/ubuntu/ansible/jenkins-slave-configurations.yml"
        ANSIBLE_KEY = "/home/ubuntu/.ssh/terraform-ec2-key.pem"
        ANSIBLE_USER = "ubuntu"
        IMAGE_TAR = "/tmp/php-app_${env.BRANCH_NAME}.tar"
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
                sh "sudo docker build -t $DOCKER_IMAGE ./website"
            }
        }

        stage('Test Docker Image') {
            steps {
                echo "Running test container to verify PHP..."
                sh "sudo docker run --rm $DOCKER_IMAGE php -v"
            }
        }

        stage('Save Docker Image for Deployment') {
            steps {
                echo "Saving Docker image to tar for Ansible transfer..."
                sh "sudo docker save $DOCKER_IMAGE -o $IMAGE_TAR"
            }
        }

        stage('Deploy via Ansible') {
            steps {
                script {
                    // Map branch names to inventory groups
                    def envMap = ['dev':'dev', 'stage':'stage', 'master':'prod']
                    def target = envMap[env.BRANCH_NAME]

                    if (target) {
                        echo "Deploying to ${target.toUpperCase()} server(s)"
                        sh """
                            ansible-playbook -i $ANSIBLE_INVENTORY \
                            $ANSIBLE_PLAYBOOK \
                            --limit ${target} \
                            -u $ANSIBLE_USER \
                            --private-key=$ANSIBLE_KEY \
                            -e target_env=${target} \
                            -e image_tar=$IMAGE_TAR
                        """
                    } else {
                        echo "Branch ${env.BRANCH_NAME} is not mapped to any environment. Skipping deploy."
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Build, test, and deployment completed successfully on branch ${env.BRANCH_NAME}!"
        }
        failure {
            echo "Pipeline failed on branch ${env.BRANCH_NAME}. Check Jenkins console for details."
        }
    }
}

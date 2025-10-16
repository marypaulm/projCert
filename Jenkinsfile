pipeline {
    agent { label 'php-slave' }

    environment {
        DOCKER_IMAGE = "php-app:${env.BRANCH_NAME}"
        REPO_URL = "https://github.com/marypaulm/projCert.git"
        ECR_URI = "381492070404.dkr.ecr.eu-central-1.amazonaws.com/php-app"
        ANSIBLE_INVENTORY = "/home/ubuntu/ansible/hosts"
        ANSIBLE_PLAYBOOK = "/home/ubuntu/ansible/jenkins-slave-configurations.yml"
        ANSIBLE_KEY = "/home/ubuntu/.ssh/terraform-ec2-key.pem"
        ANSIBLE_USER = "ubuntu"
        HOST_PORT = "8080"   // Add host port for container mapping
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

        stage('Push Docker Image to ECR') {
            steps {
                echo "Tagging and pushing Docker image to ECR..."
                withCredentials([usernamePassword(
                    credentialsId: 'awsecrlogin',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh """
                        aws ecr get-login-password --region eu-central-1 | \
                        sudo docker login --username AWS --password-stdin 381492070404.dkr.ecr.eu-central-1.amazonaws.com
                        sudo docker tag $DOCKER_IMAGE $ECR_URI:${env.BRANCH_NAME}
                        sudo docker push $ECR_URI:${env.BRANCH_NAME}
                    """
                }
            }
        }

        stage('Deploy via Ansible') {
            steps {
                script {
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
                            -e image_name=$ECR_URI:${env.BRANCH_NAME} \
                            -e host_port=$HOST_PORT
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
            echo "Build, test, push to ECR, and deployment completed successfully on branch ${env.BRANCH_NAME}!"
        }
        failure {
            echo "Pipeline failed on branch ${env.BRANCH_NAME}. Check Jenkins console for details."
        }
    }
}

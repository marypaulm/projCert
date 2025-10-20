pipeline {
    agent { label 'php-slave' }

    environment {
        REPO_URL = "https://github.com/marypaulm/projCert.git"
        ECR_URI = "381492070404.dkr.ecr.eu-central-1.amazonaws.com/php-app"
        ANSIBLE_INVENTORY = "/home/ubuntu/ansible/hosts"
        ANSIBLE_PLAYBOOK = "/home/ubuntu/ansible/jenkins-slave-configurations.yml"
        ANSIBLE_KEY = "/home/ubuntu/.ssh/terraform-ec2-key.pem"
        ANSIBLE_USER = "ubuntu"
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
                script {
                    env.DOCKER_TAG = env.BRANCH_NAME
                    env.DOCKER_IMAGE = "php-app:${env.DOCKER_TAG}"
                    echo "Building Docker image: ${env.DOCKER_IMAGE}"
                }
                sh "sudo docker build -t $DOCKER_IMAGE ./website"
                
                // Tag the image as latest
                sh "sudo docker tag $DOCKER_IMAGE $ECR_URI:latest"
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
                        sudo docker login --username AWS --password-stdin $ECR_URI

                        # Push branch-specific image
                        sudo docker push $ECR_URI:${env.DOCKER_TAG}

                        # Push latest tag
                        sudo docker push $ECR_URI:latest
                    """
                }
            }
        }

        stage('Deploy via Ansible') {
            steps {
                script {
                    // Map Git branches to Ansible inventory groups
                    def envMap = ['dev':'dev', 'stage':'stage', 'master':'prod']
                    def target = envMap[env.BRANCH_NAME]

                    if (target) {
                        echo "Deploying to ${target.toUpperCase()} server(s) using latest tag..."
                        sh """
                            ansible-playbook -i $ANSIBLE_INVENTORY \
                            $ANSIBLE_PLAYBOOK \
                            --limit ${target} \
                            -u $ANSIBLE_USER \
                            --private-key=$ANSIBLE_KEY \
                            -e target_env=${target} \
                            -e image_name=$ECR_URI:latest
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

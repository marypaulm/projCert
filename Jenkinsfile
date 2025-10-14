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

        stage('Run Application on Server') {
            steps {
                script {
                    echo "Starting application container on server..."
                    sh """
                        if [ "${env.BRANCH_NAME}" == "dev" ]; then
                            TARGET=dev
                        elif [ "${env.BRANCH_NAME}" == "stage" ]; then
                            TARGET=stage
                        elif [ "${env.BRANCH_NAME}" == "master" ]; then
                            TARGET=prod
                        else
                            echo "No target for branch ${env.BRANCH_NAME}, skipping run."
                            exit 0
                        fi

                        ansible -i $ANSIBLE_INVENTORY $TARGET -m shell -a '
                            sudo docker stop php-app-${env.BRANCH_NAME} || true
                            sudo docker rm php-app-${env.BRANCH_NAME} || true
                            sudo docker run -d --name php-app-${env.BRANCH_NAME} -p 80:80 $DOCKER_IMAGE
                        '
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Build, test, deployment, and application start completed successfully on branch ${env.BRANCH_NAME}!"
        }
        failure {
            echo "Pipeline failed on branch ${env.BRANCH_NAME}. Check Jenkins console for details."
        }
    }
}

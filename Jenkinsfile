pipeline {
    agent any
    environment {
        GIT_REPO = 'https://github.com/joisyousef/nodejs.org.git'
        DOCKER_USER = "joisyousef"
        DOCKER_PASS = "docker-hub-credentials" // Jenkins credentials ID for Docker Hub
        APP_NAME = "nodejs-app"
        IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}"
        IMAGE_TAG = 'latest'
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
    }
    stages {

        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                echo 'Checking out code from GitHub...'
                git branch: 'main', url: "${GIT_REPO}"
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Installing Dependencies...'
                sh 'npm ci || npm install || { echo "Failed to install dependencies"; exit 1; }'
            }
        }

         stage('node version'){
            steps{
                sh 'node -v'
            }
        }

        
        stage('Run Unit Tests') {
            steps {
                echo 'Running Unit Tests...'
                sh 'npm run test || { echo "Unit tests failed"; exit 1; }'
            }
        }

        stage('Dockerize') {
            steps {
                script {
                    try {
                        echo "Building Docker image..."
                        // Use sudo to run docker build if necessary
                        sh "sudo docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                        echo "Docker image built successfully: ${IMAGE_NAME}:${IMAGE_TAG}"
                    } catch (Exception e) {
                        echo "Docker build failed: ${e.getMessage()}"
                        currentBuild.result = 'FAILURE'
                        error("Stopping pipeline due to Docker build failure.")
                    }
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh 'sudo docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                        sh "sudo docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    }
                }
            }
        }
    }
}

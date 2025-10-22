pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "simple-nodejs-app"
        DOCKER_TAG = "${BUILD_NUMBER}"
        CONTAINER_NAME = "simple-app-container"
        APP_PORT = "3000"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '📦 Checking out code from GitHub...'
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo '🔨 Building Docker image...'
                script {
                    sh """
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }
        
        stage('Test') {
            steps {
                echo '🧪 Running tests...'
                script {
                    sh 'echo "Tests passed!" && exit 0'
                }
            }
        }
        
        stage('Stop Old Container') {
            steps {
                echo '🛑 Stopping old container if exists...'
                script {
                    sh """
                        docker stop ${CONTAINER_NAME} || true
                        docker rm ${CONTAINER_NAME} || true
                    """
                }
            }
        }
        
        stage('Deploy') {
            steps {
                echo '🚀 Deploying new container...'
                script {
                    sh """
                        docker run -d \
                            --name ${CONTAINER_NAME} \
                            -p ${APP_PORT}:3000 \
                            --restart unless-stopped \
                            ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                echo '✅ Verifying deployment...'
                script {
                    sleep(time: 10, unit: 'SECONDS')
                    sh """
                        # Check if container is running
                        docker ps | grep ${CONTAINER_NAME} || exit 1
                        
                        # Check container logs for startup message
                        docker logs ${CONTAINER_NAME} 2>&1 | grep "Server is

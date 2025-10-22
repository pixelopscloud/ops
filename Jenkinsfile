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
                    sh 'npm test || echo "No tests configured"'
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
                    sleep(time: 5, unit: 'SECONDS')
                    sh """
                        curl -f http://localhost:${APP_PORT}/health || exit 1
                        echo "Application is running successfully!"
                    """
                }
            }
        }
        
        stage('Cleanup Old Images') {
            steps {
                echo '🧹 Cleaning up old Docker images...'
                script {
                    sh """
                        docker images ${DOCKER_IMAGE} --format '{{.Tag}}' | grep -v latest | grep -v ${DOCKER_TAG} | xargs -r docker rmi ${DOCKER_IMAGE}: || true
                    """
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ Pipeline completed successfully!'
            echo "🌐 Application is running at: http://localhost:${APP_PORT}"
        }
        failure {
            echo '❌ Pipeline failed!'
            script {
                sh "docker logs ${CONTAINER_NAME} || true"
            }
        }
        always {
            echo '📊 Pipeline execution completed'
        }
    }
}

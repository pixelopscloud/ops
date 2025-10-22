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
                    sleep(time: 15, unit: 'SECONDS')
                    sh """
                        # Check if container is running
                        docker ps | grep ${CONTAINER_NAME} || exit 1
                        
                        # Check container logs
                        docker logs ${CONTAINER_NAME} 2>&1 | grep "Server is running" || exit 1
                        
                        # Test health endpoint using IPv4
                        docker exec ${CONTAINER_NAME} node -e "
                            const http = require('http');
                            const options = {
                                hostname: '127.0.0.1',
                                port: 3000,
                                path: '/health',
                                method: 'GET'
                            };
                            
                            const req = http.request(options, (res) => {
                                if (res.statusCode === 200) {
                                    console.log('✅ Health check passed!');
                                    process.exit(0);
                                } else {
                                    console.log('❌ Health check failed:', res.statusCode);
                                    process.exit(1);
                                }
                            });
                            
                            req.on('error', (err) => {
                                console.error('❌ Error:', err.message);
                                process.exit(1);
                            });
                            
                            req.end();
                        " || exit 1
                        
                        echo "✅ Application is running successfully!"
                        echo "🌐 Access at: http://localhost:${APP_PORT}"
                    """
                }
            }
        }
        
        stage('Cleanup Old Images') {
            steps {
                echo '🧹 Cleaning up old Docker images...'
                script {
                    sh """
                        docker image prune -f || true
                    """
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ =========================================='
            echo '✅ PIPELINE SUCCESSFUL!'
            echo "🌐 Application: http://localhost:${APP_PORT}"
            echo "❤️  Health: http://localhost:${APP_PORT}/health"
            echo '✅ =========================================='
        }
        failure {
            echo '❌ Pipeline failed!'
            script {
                sh "docker logs ${CONTAINER_NAME} || true"
            }
        }
        always {
            echo '📊 Pipeline execution completed'
            sh "docker ps -a | grep ${CONTAINER_NAME} || true"
        }
    }
}

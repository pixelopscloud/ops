pipeline {
    agent any
    stages {
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
        stage('Build') {
            steps {
                echo 'Build successful!'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t pipeline-demo .'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploy step (can integrate real deployment later)'
            }
        }
    }
}


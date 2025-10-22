# Simple Node.js Application with CI/CD

A simple Node.js Express application demonstrating CI/CD pipeline with Jenkins and Docker.

## 🚀 Features
- Express.js REST API
- Docker containerization
- Jenkins CI/CD pipeline
- Health check endpoints
- Automated deployment

## 📋 Prerequisites
- Docker installed
- Jenkins running
- GitHub account

## 🔧 Local Development

### Install Dependencies
npm install

### Run Locally
npm start

### Run with Docker
docker build -t simple-nodejs-app .
docker run -d -p 3000:3000 --name my-app simple-nodejs-app

## 📡 API Endpoints
- GET / - Welcome message
- GET /health - Health check
- GET /api/info - App information

## 🌐 Access Application
- Application: http://localhost:3000
- Health Check: http://localhost:3000/health
- API Info: http://localhost:3000/api/info

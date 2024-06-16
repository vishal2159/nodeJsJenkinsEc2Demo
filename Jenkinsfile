pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "your-dockerhub-username/my-node-app"
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/vishal2159/nodeJsJenkinsEc2Demo.git', credentialsId: 'github-credentials'
            }
        }
        stage('Install Dependencies') {
            agent {
                docker {
                    image 'node:14'
                }
            }
            steps {
                sh 'npm install'
            }
        }
        stage('Run Tests') {
            agent {
                docker {
                    image 'node:14'
                }
            }
            steps {
                sh 'npm test'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials-id') {
                        docker.image("${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}").push()
                    }
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-credentials-id']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ec2-user@your-ec2-public-dns << EOF
                    docker pull ${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}
                    docker stop my-node-app || true
                    docker rm my-node-app || true
                    docker run -d --name my-node-app -p 80:3000 ${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}
                    EOF
                    """
                }
            }
        }
    }
}

pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "992382592515.dkr.ecr.us-east-1.amazonaws.com/nodejs:latest"
        REGISTRY_CREDENTIALS = 'dockerhub-credentials-id'
        CONTAINER_NAME = "nodejs-demo"
    }

    echo 'CONTAINER_NAME', CONTAINER_NAME

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/vishal2159/nodeJsJenkinsEc2Demo.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    def nodeHome = tool name: 'NodeJS', type: 'NodeJSInstallation'
                    env.PATH = "${nodeHome}/bin:${env.PATH}"
                    sh 'npm install'
                }
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', REGISTRY_CREDENTIALS) {
                        sh 'docker push $DOCKER_IMAGE'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh 'docker run -d -p 80:80 --name $CONTAINER_NAME $DOCKER_IMAGE'
                }
            }
        }
    }

    post {
        success {
            echo 'Build and deployment successful!'
        }
        failure {
            mail to: 'vishal2159@gmail.com',
                 subject: "Jenkins Job '${env.JOB_NAME}' (${env.BUILD_NUMBER}) Failed",
                 body: "Job '${env.JOB_NAME}' (${env.BUILD_NUMBER}) failed. Check Jenkins for more details."
        }
    }
}

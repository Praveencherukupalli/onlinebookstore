pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'praveencherukupalli28/onlinebookstore'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Praveencherukupalli/onlinebookstore.git'
            }
        }

        stage('Build') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:$BUILD_NUMBER .'
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-password', variable: 'DOCKERHUB_PASS')]) {
                    sh """
                      echo $DOCKERHUB_PASS | docker login -u  --password-stdin
                      docker push $DOCKER_IMAGE:$BUILD_NUMBER
                      docker tag $DOCKER_IMAGE:$BUILD_NUMBER $DOCKER_IMAGE:latest
                      docker push $DOCKER_IMAGE:latest
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                sh "docker run -d -p 8080:8080 $DOCKER_IMAGE:latest"
            }
        }
    }
}

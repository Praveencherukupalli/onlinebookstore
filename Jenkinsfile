pipeline {
  {
  agent {
    docker {
      image 'abhishekf5/maven-abhishek-docker-agent:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
    }
  }
  stages {
    stage('Checkout') {
      steps {
        sh 'echo passed'
        git 'https://github.com/Praveencherukupalli/onlinebookstore.git'
      }
    }

    stage('Build with Maven') {
      steps {
        sh 'cd onlinebookatore && mvn clean package'
      }
    }
    stage('Static Code Analysis') {
      environment {
        SONAR_URL = "http://44.212.35.176:9000"
      }
      steps {
        withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
          sh 'cd onlinebookstore && mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}'
        }
      }
    }

    stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "onlinebookstore:${BUILD_NUMBER}"
        // DOCKERFILE_LOCATION = "https://github.com/Praveencherukupalli/onlinebookstore/blob/master/Dockerfile"
        REGISTRY_CREDENTIALS = credentials('docker-cred')
      }
      steps {
        script {
            sh 'cd onlinebookstore && docker build -t ${DOCKER_IMAGE} .'
            def dockerImage = docker.image("${DOCKER_IMAGE}")
            docker.withRegistry('https://index.docker.io/v1/', "docker-cred") {
                dockerImage.push()
            }

          }
        }
      }
    

    stage('Deploy Docker Container') {
      steps {
        script {
          sh '''
            docker rm -f ${CONTAINER_NAME} || true
            docker run -d -p 3000:8080 --name ${CONTAINER_NAME} ${IMAGE_NAME}:latest
          '''
        }
      }
    }
  }
  }
}
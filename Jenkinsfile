pipeline {
  agent {
    docker {
      image 'abhishekf5/maven-abhishek-docker-agent:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
    }
  }

  environment {
    IMAGE_NAME = 'praveencherukupalli28/onlinebookstore'
    CONTAINER_NAME = 'myapp'
  }

  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/Praveencherukupalli/onlinebookstore.git'
      }
    }

    stage('Build with Maven') {
      steps {
        sh 'mvn clean package'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          docker.build("${IMAGE_NAME}:latest")
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          script {
            sh '''
              echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
              docker push ${IMAGE_NAME}:latest
            '''
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

  p

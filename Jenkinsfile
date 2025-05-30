pipeline {
  agent any

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
          sh '''
            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
            docker push ${IMAGE_NAME}:latest
          '''
        }
      }
    }

    stage('Deploy Docker Container') {
      steps {
        script {
          // Remove old container if exists
          sh "docker rm -f ${CONTAINER_NAME} || true"
          // Run container mapping port 8080 inside container to 3000 on host
          sh "docker run -d -p 3000:8080 --name ${CONTAINER_NAME} ${IMAGE_NAME}:latest"
        }
      }
    }
  }

  post {
    failure {
      echo "Build failed - Email notifications disabled or configure SMTP"
      // Optionally add email step here if SMTP configured
    }
  }
}

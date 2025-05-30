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
          sh "docker rm -f ${CONTAINER_NAME} || true"
          sh "docker run -d -p 3000:3000 --name ${CONTAINER_NAME} ${IMAGE_NAME}:latest"
        }
      }
    }
  }

  post {
    success {
      mail to: 'team@example.com',
           subject: "✅ CI/CD Success - ${env.JOB_NAME}",
           body: "Deployment succeeded!"
    }
    failure {
      mail to: 'team@example.com',
           subject: "❌ CI/CD Failure - ${env.JOB_NAME}",
           body: "Check Jenkins for errors."
    }
  }
}

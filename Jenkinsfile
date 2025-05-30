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
          sh "docker rm -f ${CONTAINER_NAME} || true"
          sh "docker run -d -p 3000:3000 --name ${CONTAINER_NAME} ${IMAGE_NAME}:latest"
        }
      }
    }
  }
  post {
    failure {
        mail to: 'you@example.com',
             subject: "Jenkins Build Failed",
             body: "Check Jenkins job: ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}"
    }
}

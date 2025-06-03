pipeline {
<<<<<<< HEAD
    agent any

    environment {
        DOCKER_IMAGE = 'praveencherukupalli28/onlinebookstore'
        DOCKER_TAG = 'latest'
        SONARQUBE_ENV = 'SonarQube' // Jenkins config name for SonarQube server
    }

    tools {
        maven 'Maven 3'
        sonarQubeScanner 'SonarQube Scanner'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_AUTH_TOKEN')]) {
                    withSonarQubeEnv("${SONARQUBE_ENV}") {
                        sh 'mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN'
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Cleanup') {
            steps {
                sh 'docker system prune -f'
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed.'
=======
  agent {
    docker {
        image 'maven:3.8.6-eclipse-temurin-17-alpine'
        args '-v /root/.m2:/root/.m2'
    }
}
 environment {
    SONAR_URL = "http://18.209.60.235:9000"
    DOCKER_IMAGE = "praveencherukupalli/onlinebookstore:${BUILD_NUMBER}"
    CONTAINER_NAME = "onlinebookstore-container"
    REGISTRY_CREDENTIALS = credentials('docker-cred')
  }

  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/Praveencherukupalli/onlinebookstore.git'
      }
    }

    stage('Build with Maven') {
      steps {
        sh 'cd onlinebookstore && mvn clean package'
      }
    }

    stage('Static Code Analysis') {
      steps {
        withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
          sh '''
            cd onlinebookstore
            mvn sonar:sonar \
              -Dsonar.login=$SONAR_AUTH_TOKEN \
              -Dsonar.host.url=${SONAR_URL}
          '''
        }
      }
    }

    stage('Build and Push Docker Image') {
      steps {
        script {
          sh '''
            cd onlinebookstore
            docker build -t ${DOCKER_IMAGE} .
          '''
          docker.withRegistry('https://index.docker.io/v1/', "docker-cred") {
            docker.image("${DOCKER_IMAGE}").push()
          }
        }
      }
    }

    stage('Deploy Docker Container') {
      steps {
        script {
          sh '''
            docker rm -f ${CONTAINER_NAME} || true
            docker run -d -p 3000:8080 --name ${CONTAINER_NAME} ${DOCKER_IMAGE}
          '''
>>>>>>> 3847c5e834c3f29bb731f6e5280195ca72def829
        }
    }
<<<<<<< HEAD
}
=======
  }
}
>>>>>>> 3847c5e834c3f29bb731f6e5280195ca72def829

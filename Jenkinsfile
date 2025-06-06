pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'praveencherukupalli28/onlinebookstore'
        DOCKER_TAG = 'latest'
        SONARQUBE_ENV = 'SonarQube' // Jenkins config name for SonarQube server
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

        stage('Verify Build Artifacts') {
            steps {
                sh 'ls -lh target'
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
                // No cache to ensure rebuild and fresh JAR copy
                sh "docker build --no-cache -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
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
        }
    }
}

pipeline {

    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '3', artifactNumToKeepStr: '3'))
    }

    tools {
        maven 'maven_3.9.10'
    }

    stages {
        stage('Code Compilation') {
            steps {
                echo 'Code Compilation is In Progress!'
                sh 'mvn clean compile'
                echo 'Code Compilation is Completed Successfully!'
            }
        }

        stage('Code QA Execution') {
            steps {
                echo 'JUnit Test Case Check in Progress!'
                sh 'mvn clean test'
                echo 'JUnit Test Case Check Completed!'
            }
        }

        stage('Code Package') {
            steps {
                echo 'Creating JAR Artifact'
                sh 'mvn clean package -DskipTests'
                sh 'mv target/booking-ms-*.jar target/booking-ms.jar'
                echo 'Artifact Creation Completed'
            }
        }

        stage('Building & Tag Docker Image') {
            steps {
                echo 'Starting Building Docker Image'
                sh 'docker build -t gauravbagate8/booking-ms .'
                echo 'Docker Image Build Completed'
            }
        }

        stage('Docker Image Scanning') {
            steps {
                echo 'Docker Image Scanning Started'
                sh 'docker --version'
                echo 'Docker Image Scanning Completed'
            }
        }

        stage('Docker push to Docker Hub') {
            steps {
                  withCredentials([string(credentialsId: 'dockerhubCred', variable: 'dockerhubCred')]){
                                   sh 'docker login docker.io -u gauravbagate8 -p ${dockerhubCred}'
                                   echo "Push Docker Image to DockerHub : In Progress"
                                   sh 'docker push gauravbagate8/booking-ms:latest'
                                   echo "Push Docker Image to DockerHub : In Progress"
                }
            }
        }

        stage('Docker Image Push to Amazon ECR') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'ecr:ap-south-1:ecr-credentials', url: "https://533267238276.dkr.ecr.ap-south-1.amazonaws.com"]) {
                        sh """
                            echo "List the docker images present in local"
                            docker images
                            echo "Tagging the Docker Image: In Progress"
                            docker tag gauravbagate8/booking-ms:latest 533267238276.dkr.ecr.ap-south-1.amazonaws.com/booking-ms:latest
                            echo "Tagging the Docker Image: Completed"
                            echo "Push Docker Image to ECR: In Progress"
                            docker push 533267238276.dkr.ecr.ap-south-1.amazonaws.com/booking-ms:latest
                            echo "Push Docker Image to ECR: Completed"
                        """
                    }
                }
            }
        }
    }
}
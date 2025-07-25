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

        stage('Upload the docker Image to Nexus') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'nexuscred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh 'docker login http://13.235.254.242:8085/repository/booking-ms/ -u admin -p ${PASSWORD}'
                        echo "Push Docker Image to Nexus : In Progress"
                        sh 'docker tag gauravbagate8/booking-ms 13.235.254.242:8085/booking-ms:latest'
                        sh 'docker push 13.235.254.242:8085/booking-ms'
                        echo "Push Docker Image to Nexus : Completed"
                    }
                }
            }
        }

    }
}
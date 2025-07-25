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

        stage('Sonarqube') {
            environment {
                scannerHome = tool 'qube'
            }
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                    sh 'mvn sonar:sonar'
                }
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
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
    }
}
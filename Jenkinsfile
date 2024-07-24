pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    environment {
        JAVA_HOME = 'C:\\Program Files\\Eclipse Adoptium\\jdk-11.0.23.9-hotspot'
        PATH = "${env.JAVA_HOME}\\bin;${env.PATH}"
        AWS_ACCESS_KEY_ID = credentials('jenkins_aws_acesskey')
        AWS_DEFAULT_REGION = 'us-east-1'
        EC2_INSTANCE_IP = '44.202.219.231'
        SSH_KEY_PATH = 'aws_ssh_private'
    }

    stages {
        stage('Build') {
            steps {
                bat 'mvn clean package'
            }
        }

        stage('Test') {
            steps {
                bat 'mvn test'
            }
        }

        stage('Deploy to AWS EC2') {
            steps {
                script {
                  withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                           accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                           credentialsId: 'jenkins_aws_acesskey', ]])
                     {
                        def localPath = 'target/demo-0.0.1-SNAPSHOT.jar'
                        def remotePath = '/home/ubuntu/demo.jar'
                         
                        bat "scp -i %SSH_KEY_PATH% ${localPath} ubuntu@${env.EC2_INSTANCE_IP}:${remotePath}"
                      
                        bat "ssh -i %SSH_KEY_PATH% ubuntu@${env.EC2_INSTANCE_IP} 'java -jar ${remotePath}'"
                    }
                }
            }
        }
    }
}

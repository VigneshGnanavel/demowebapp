pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    environment {
        JAVA_HOME = 'C:\\Program Files\\Eclipse Adoptium\\jdk-11.0.23.9-hotspot'
        PATH = "${env.JAVA_HOME}\\bin;${env.PATH}"
        AWS_ACCESS_KEY_ID = credentials('jenkins_aws_acesskey')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_acesskey')
        AWS_DEFAULT_REGION = 'us-east-1'
        EC2_INSTANCE_IP = '44.202.219.231'
        SSH_KEY = credentials('aws_ssh_private') // Updated credentials ID
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
                    withCredentials([
                        sshUserPrivateKey(credentialsId: 'aws_ssh_private', keyFileVariable: 'SSH_KEY_PATH')
                    ]) {
                        def localPath = 'target/demo-0.0.1-SNAPSHOT.jar' // Adjust to your JAR file name
                        def remotePath = '/home/ubuntu/demo.jar' // Path on your EC2 instance

                        // Copy the artifact to the EC2 instance using SCP
                        bat "scp -i %SSH_KEY_PATH% ${localPath} ubuntu@${env.EC2_INSTANCE_IP}:${remotePath}"

                        // SSH into the EC2 instance and run the application
                        bat "ssh -i %SSH_KEY_PATH% ubuntu@${env.EC2_INSTANCE_IP} 'java -jar ${remotePath}'"
                    }
                }
            }
        }
    }
}

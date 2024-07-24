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
        S3_BUCKET_NAME = 'jenkinstrialdemos3'
        EC2_INSTANCE_IP = '44.202.219.231'
        SSH_KEY = credentials('jenkins_aws_private')
    }

    stages {
        stage('Build') {
            steps {
                bat 'mvn clean package'
            }
        }

        stage('Upload to S3') {
            steps {
                script {
                    def localPath = 'target/demo-0.0.1-SNAPSHOT.jar' // Adjust to your JAR file name
                    bat "aws s3 cp ${localPath} s3://${env.S3_BUCKET_NAME}/demo.jar"
                }
            }
        }

        stage('Deploy to AWS EC2') {
            steps {
                script {
                    withCredentials([
                        sshUserPrivateKey(credentialsId: 'jenkins_aws_private', keyFileVariable: 'SSH_KEY_PATH')
                    ]) {
                        def remotePath = '/home/ubuntu/demo.jar' // Path on your EC2 instance

                        // SSH into the EC2 instance and download the artifact from S3
                        bat """
                        ssh -i %SSH_KEY_PATH% ubuntu@${env.EC2_INSTANCE_IP} 'aws s3 cp s3://${env.S3_BUCKET_NAME}/demo.jar ${remotePath}'
                        ssh -i %SSH_KEY_PATH% ubuntu@${env.EC2_INSTANCE_IP} 'java -jar ${remotePath}'
                        """
                    }
                }
            }
        }
    }
}

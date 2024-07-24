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
        EC2_INSTANCE_ID = 'i-09fe34113de0f983c'
        EC2_KEY_PAIR_NAME = 'aws_ssh_private'
        LOCAL_JAR_PATH = 'target/demo-0.0.1-SNAPSHOT.jar'
        REMOTE_JAR_PATH = '/home/ubuntu/demo.jar'
        SSH_KEY_PATH = 'C:\\path\\to\\your\\jenkins_trial.pem'
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
                    def ec2InstanceInfo = bat(script: "aws ec2 describe-instances --instance-ids ${env.EC2_INSTANCE_ID} --query 'Reservations[0].Instances[0].PublicIpAddress' --output text", returnStdout: true).trim()

                    def remotePath = "${env.REMOTE_JAR_PATH}"

                    bat """
                    scp -i %SSH_KEY_PATH% ${env.LOCAL_JAR_PATH} ubuntu@${ec2InstanceInfo}:${remotePath}
                    """

                    bat """
                    ssh -i %SSH_KEY_PATH% ubuntu@${ec2InstanceInfo} "java -jar ${remotePath}"
                    """
                }
            }
        }
    }
}

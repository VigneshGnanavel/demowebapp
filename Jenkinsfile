pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        SSH_KEY_PATH = 'C:\\Users\\Digit\\Downloads\\jenkins_trial.pem'
        EC2_INSTANCE_IP = '44.202.219.231'
    }

    stages {
        stage('Build') {
            steps {
                bat 'mvn clean package'
            }
        }

        stage('Deploy to AWS EC2') {
            steps {
                script {
                    bat "scp -i %SSH_KEY_PATH% target/demo-0.0.1-SNAPSHOT.jar ubuntu@%EC2_INSTANCE_IP%:/home/ubuntu/demo.jar"
                    bat 'echo yes | ssh-keyscan %EC2_INSTANCE_IP% >> %USERPROFILE%\\.ssh\\known_hosts'
                    bat "ssh -i %SSH_KEY_PATH% ubuntu@%EC2_INSTANCE_IP% 'java -jar /home/ubuntu/demo.jar'"
                }
            }
        }
    }
}

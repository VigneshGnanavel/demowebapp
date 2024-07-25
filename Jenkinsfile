pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    environment {
        JAVA_HOME = 'C:\\Program Files\\Eclipse Adoptium\\jdk-11.0.23.9-hotspot'
        PATH = "${env.JAVA_HOME}\\bin;${env.PATH};C:\\Program Files\\ps_tools" // Ensure PsExec is in the PATH
        AWS_ACCESS_KEY_ID = credentials('jenkins_aws_acesskey')
        AWS_DEFAULT_REGION = 'us-east-1'
        S3_BUCKET_NAME = 'jenkinstrialdemos3'
        EC2_INSTANCE_IP = '54.86.129.41'
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
                    withCredentials([usernamePassword(credentialsId: 'windows_ec2_rdp', usernameVariable: 'RDP_USER', passwordVariable: 'RDP_PASSWORD')]) {
                        def remotePath = 'C:\\path\\to\\demo.jar' // Adjust to the correct path on your Windows instance
                        bat """
                        "C:\\Program Files\\ps_tools\\PsExec.exe" \\\\${env.EC2_INSTANCE_IP} -u %RDP_USER% -p %RDP_PASSWORD% cmd /c "aws s3 cp s3://${env.S3_BUCKET_NAME}/demo.jar ${remotePath} && java -jar ${remotePath}"
                        """
                    }
                }
            }
        }
    }
}

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
        EC2_INSTANCE_IP = '44.211.47.229'
        SSH_KEY = credentials('demo_web_app_pv')
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
                    withCredentials([sshUserPrivateKey(credentialsId: 'demo_web_app_pv', keyFileVariable: 'SSH_KEY_PATH')]) {
                        def remotePath = '/home/ubuntu/demo.jar' 

                        // Adjust file permissions using PowerShell
                        bat """
                        powershell -Command \"
                        \$acl = Get-Acl '%SSH_KEY_PATH%';
                        \$acl.SetAccessRuleProtection(\$true, \$false);
                        \$rule = New-Object System.Security.AccessControl.FileSystemAccessRule('Everyone', 'FullControl', 'Allow');
                        \$acl.RemoveAccessRule(\$rule);
                        Set-Acl -Path '%SSH_KEY_PATH%' -AclObject \$acl;
                        \"
                        ssh -o StrictHostKeyChecking=no -i %SSH_KEY_PATH% ubuntu@${env.EC2_INSTANCE_IP} "aws s3 cp s3://${env.S3_BUCKET_NAME}/demo.jar ${remotePath}"
                        ssh -o StrictHostKeyChecking=no -i %SSH_KEY_PATH% ubuntu@${env.EC2_INSTANCE_IP} "java -jar ${remotePath}"
                        """
                    }
                }
            }
        }
    }
}

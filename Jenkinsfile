pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        timeout(time: 30, unit: 'MINUTES')
    }

    environment {
        TF_IN_AUTOMATION = 'true'
        TF_INPUT         = 'false'
        TF_DIR           = 'environments/dev'
        AWS_REGION       = 'ap-south-1'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Tools and AWS Identity') {
            steps {
                sh '''
                    git --version
                    terraform version
                    aws --version
                    aws sts get-caller-identity
                '''
            }
        }

        stage('Terraform Format Check') {
            steps {
                sh 'terraform fmt -check -recursive'
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform plan -input=false -out=network.tfplan'
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform validation and planning completed successfully.'
        }

        failure {
            echo 'Pipeline failed. Review the failed stage before continuing.'
        }

        always {
            deleteDir()
        }
    }
}
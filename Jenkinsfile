pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['plan', 'apply'],
            description: 'Choose plan to preview or apply to create infrastructure'
        )
    }

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

        stage('Manual Approval') {
            when {
                expression {
                    params.ACTION == 'apply'
                }
            }

            steps {
                input(
                    message: 'Review the Terraform plan. Approve creation of the VPC networking resources?',
                    ok: 'Approve Apply'
                )
            }
        }

        stage('Terraform Apply') {
            when {
                expression {
                    params.ACTION == 'apply'
                }
            }

            steps {
                dir("${TF_DIR}") {
                    sh 'terraform apply -input=false -auto-approve network.tfplan'
                }
            }
        }
    }

    post {
        success {
            echo "Terraform ${params.ACTION} workflow completed successfully."
        }

        failure {
            echo 'Pipeline failed. Review the failed stage before continuing.'
        }

        always {
            deleteDir()
        }
    }
}
pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['plan', 'apply'],
            description: 'Choose plan to preview changes or apply the infrastructure'
        )
    }

    options {
        timestamps()
        disableConcurrentBuilds()
        timeout(time: 90, unit: 'MINUTES')
    }

    environment {
        TF_IN_AUTOMATION = 'true'
        TF_INPUT         = 'false'
        TF_DIR           = 'environments/dev'
        TF_PLAN_FILE     = 'terraform.tfplan'
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
                    set -e

                    echo "===== Git ====="
                    git --version

                    echo "===== Terraform ====="
                    terraform version

                    echo "===== AWS CLI ====="
                    aws --version
                    aws sts get-caller-identity

                    echo "===== TFLint ====="
                    tflint --version

                    echo "===== Checkov ====="
                    checkov --version

                    echo "===== Gitleaks ====="
                    gitleaks help >/dev/null
                    echo "Gitleaks is available"

                    echo "===== Trivy ====="
                    trivy --version
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

        stage('TFLint Scan') {
            steps {
                sh '''
                    set -e
                    tflint --init
                    tflint --recursive --format compact
                '''
            }
        }

        stage('Gitleaks Secret Scan') {
            steps {
                sh '''
                    set -e
                    gitleaks detect \
                        --source . \
                        --redact \
                        --verbose
                '''
            }
        }

        stage('Checkov Security Scan') {
            steps {
                sh '''
                    checkov \
                        --directory . \
                        --framework terraform \
                        --download-external-modules false \
                        --compact \
                        --soft-fail
                '''
            }
        }

        stage('Trivy IaC Scan') {
            steps {
                sh '''
                    trivy config \
                        --severity HIGH,CRITICAL \
                        --exit-code 0 \
                        .
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_DIR}") {
                    sh '''
                        terraform plan \
                            -input=false \
                            -out="${TF_PLAN_FILE}"
                    '''
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
                    message: 'Review the Terraform plan and security scan results. Approve applying the development infrastructure?',
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
                    sh '''
                        terraform apply \
                            -input=false \
                            -auto-approve \
                            "${TF_PLAN_FILE}"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Terraform ${params.ACTION} workflow completed successfully."
        }

        failure {
            echo 'Pipeline failed. Review the failed stage and console output before continuing.'
        }

        always {
            deleteDir()
        }
    }
}
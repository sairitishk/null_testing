pipeline {
    agent any
    parameters {
        booleanParam(name: 'DESTROY_RESOURCES', defaultValue: false, description: 'Check to destroy resources')
    }
    stages {
        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                script {
                    // Validate Terraform files
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Generate and show an execution plan
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply the changes required to reach the desired state of the configuration
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression {
                    return params.DESTROY_RESOURCES == true
                }
            }
            steps {
                script {
                    // Destroy the Terraform-managed infrastructure
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }

    post {
        always {
            // Clean up workspace after build
            cleanWs()
        }
        success {
            // Archive Terraform plan or logs on success
            archiveArtifacts artifacts: 'tfplan', allowEmptyArchive: true
        }
        failure {
            // Notify on failure
            mail to: 'your-email@example.com',
                 subject: "Failed Pipeline: ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                 body: "Something is wrong with ${env.JOB_NAME} [${env.BUILD_NUMBER}]."
        }
    }
}

pipeline {
  agent any
  environment {
    AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    AWS_DEFAULT_REGION = "us-east-1"
  }
  stages {
    stage('Checkout SCM') {
      steps {
        script {
          checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/username/repository-name.git']])
        }
      }
    }
    stage('Initializing Terraform') {
      steps {
        script {
          dir('EKS-Cluster') {
            sh 'terraform init'
          }
        }
      }
    }
    stage('Formatting Terraform') {
      steps {
        script {
          dir('EKS-Cluster') {
            sh 'terraform fmt'
          }
        }
      }
    }
    stage('Validating Terraform') {
      steps {
        script {
          dir('EKS-Cluster') {
            sh 'terraform validate'
          }
        }
      }
    }
    stage('Dry-Run Terraform (Plan)') {
      steps {
        script {
          dir('EKS-Cluster') {
            sh 'terraform plan'
          }
          input(message: "Are you sure to proceed?", ok: "Proceed")
        }
      }
    }
    stage('Creating/Destroying EKS Cluster') {
      steps {
        script {
          dir('EKS-Cluster') {
            sh 'terraform $action --auto-approve'
          }
        }
      }
    }
    stage('Deploying Nginx Application') {
      steps {
        script {
          dir('EKS-Cluster/Configuration-files') {
            sh 'aws eks update-kubeconfig --name my-eks-cluster'
            sh 'kubectl apply -f deployment.yaml'
            sh 'kubectl apply -f service.yaml'
          }
        }
      }
    }
  }
  parameters {
    choice(name: 'action', choices: ['apply', 'destroy'], description: 'Action to be performed by Terraform')
  }
}

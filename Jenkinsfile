pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'docker compose build'
            }
        }
        stage('Test') {
            steps {
                sh 'docker compose run --rm hello-world go test -v ./...'
            }
        }
    }

    post {
        always {
            sh 'docker compose down'
        }
    }
}

pipeline {
    agent any

    stages {
    stage('Test') {
                steps {
                    sh 'docker compose run --rm hello-world go test -v ./...'
                }
            }
        stage('Build') {
            steps {
                sh 'docker compose build'
            }
        }
    }

    post {
        always {
            sh 'docker compose down'
        }
    }
}

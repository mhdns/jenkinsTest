pipeline {
    agent any
    stages {
        stage('SCM') {
            steps {
                checkout scm
            }
        }
        stage('Docker cleanup') {
            steps {
                sh '''
                    echo "Pruning Docker resources..."
                    docker container prune -f
                    docker image prune -f
                    # Uncomment the next line if you want to be aggressive:
                    docker system prune -af --volumes
                '''
            }
        }
        stage('Test') {
            steps {
                sh 'docker compose run --rm hello-world go test -v ./... -coverprofile=/app/coverage.out'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    withSonarQubeEnv('SonarQubeCloud') {
                        sh """
                           ${scannerHome}/bin/sonar-scanner \
                             -Dsonar.projectKey=your-go-project \
                             -Dsonar.sources=. \
                             -Dsonar.exclusions=vendor/**,testdata/** \
                             -Dsonar.tests=. \
                             -Dsonar.test.inclusions=*_test.go \
                             -Dsonar.test.exclusions=vendor/**
                       """
                    }
                }
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

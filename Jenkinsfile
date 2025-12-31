pipeline {
    agent any

    environment {
        AWS_REGION = "ap-southeast-1"
        IMAGE_TAG = "v0.0.1"
        REGISTRY = "public.ecr.aws"
        NAMESPACE = "o7i4d3b7"
        REPO_NAME = "mhdns/hello-world"
    }

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
//                 sh 'docker compose run --rm hello-world go test -v ./... -coverprofile=/app/coverage.out'
                sh '''
                docker run --rm -v $(pwd):/app -w /app golang:1.25-alpine sh -c "
                    go mod download &&
                    go test -v ./... -coverprofile=../coverage.out
                "
                '''
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    withSonarQubeEnv('SonarQubeCloud') {
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }

//         stage('Quality Gate') {
//             steps {
//                 timeout(time: 2, unit: 'MINUTES') {
//                     waitForQualityGate abortPipeline: true
//                 }
//             }
//         }


        stage('Build') {
            steps {
                sh 'docker compose build'
            }
        }
        stage('Deploy') {
            when {
                branch 'release/*'
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                              credentialsId: 'aws-ecr']]) {
                sh '''
                  aws ecr-public get-login-password --region $AWS_REGION |
                  docker login --username AWS --password-stdin $REGISTRY

                  docker build -t hello-world:$IMAGE_TAG .

                  docker tag hello-world:$IMAGE_TAG \
                  $REGISTRY/$NAMESPACE/$REPO_NAME:$IMAGE_TAG

                  docker push \
                  $REGISTRY/$NAMESPACE/$REPO_NAME:$IMAGE_TAG
                '''
                }
            }
        }
    }
    post {
        always {
            sh 'docker compose down'
        }
    }
}

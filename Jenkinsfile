pipeline {
    agent any

    environment {
        DOCKER_HUB_USERNAME = "tsheri"
        GITHUB_USERNAME =  "TsheriSherpa"
        IMAGE = "${DOCKER_HUB_USERNAME}/image-uploader:latest"  // Replace with your Docker Hub image
        NAMESPACE = "dev"  // Change to 'prod' for production
    }

    stages {
        stage('Checkout') {
            steps {
                git "https://github.com/${GITHUB_USERNAME}/image-uploader.git" // Replace with your repo URL
            }
        }

        stage('Install Dependencies') {
            steps {
                sh """
                # Create a virtual environment for testing
                python3 -m venv venv
                . venv/bin/activate

                # Install dependencies (Flask, pytest, etc.)
                pip3 install --upgrade pip
                pip3 install -r requirements.txt
                pip3 install pytest
                """
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh """
                . venv/bin/activate
                pytest tests/ --maxfail=1 --disable-warnings -v
                """
            }
        }

        stage('Setup Kubernetes') {
            steps {
                sh """
                # Use Minikube contexts
                kubectl config use-context minikube

                # Create namespace if it doesn't exist
                kubectl --insecure-skip-tls-verify=true get ns ${NAMESPACE} || kubectl create ns ${NAMESPACE}
                """
            }
        }

        stage('Deploy with Helm') {
            steps {
                sh """
                helm upgrade --install image-uploader ./ \
                    --namespace ${NAMESPACE} \
                    --set image.repository=${DOCKER_HUB_USERNAME}/image-uploader \
                    --set image.tag=latest
                """
            }
        }
    }

    post {
        success {
            echo "Tests passed and deployment of image-uploader successfull!"
        }
        failure {
            echo "Pipeline failed. Check the logs for test or deployment errors."
        }
    }
}

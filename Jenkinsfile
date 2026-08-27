pipeline {
    agent any
    environment {
        HARBOR_URL = "192.168.5.12"
        PROJECT = "cicd-demo"
        IMAGE = "${HARBOR_URL}/${PROJECT}/demo:${BUILD_NUMBER}"
    }
    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }
    stages {
        stage('构建镜像') {
            steps {
                sh "/usr/bin/docker build -t ${IMAGE} ."
            }
        }
        stage('推送Harbor') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'harbor-auth', passwordVariable: 'PWD', usernameVariable: 'USER')]) {
                    sh """
                    /usr/bin/docker login ${HARBOR_URL} -u ${USER} -p ${PWD}
                    /usr/bin/docker push ${IMAGE}
                    """
                }
            }
        }
        stage('部署K3s') {
            steps {
                sh """
                kubectl apply -f k8s-deploy.yaml
                kubectl rollout restart deployment cicd-demo || true
                """
            }
        }
    }
    post {
        always { deleteDir() }
    }
}

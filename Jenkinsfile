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
        stage('拉取代码') {
            steps {
                deleteDir()
                git url: 'git@github.com:endiow/cicd-demo2.git', credentialsId: 'git-ssh-key'
            }
        }
        stage('构建镜像') {
            steps {
                sh "docker build -t ${IMAGE} ."
            }
        }
        stage('推送Harbor') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'harbor-auth', passwordVariable: 'PWD', usernameVariable: 'USER')]) {
                    sh '''
                    docker login ${HARBOR_URL} -u ${USER} -p ${PWD}
                    docker push ${IMAGE}
                    '''
                }
            }
        }
        stage('部署K3s') {
            steps {
                sh "kubectl apply -f k8s-deploy.yaml"
                sh "kubectl rollout restart deployment cicd-demo"
            }
        }
    }
    post {
        always { deleteDir() }
    }
}

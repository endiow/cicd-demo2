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
        // 关闭流水线自动checkout，如果你想自己手动控制git拉取，开启下面这行；二选一
        // skipDefaultCheckout true
    }
    stages {
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
        always { 
            deleteDir() 
        }
    }
}

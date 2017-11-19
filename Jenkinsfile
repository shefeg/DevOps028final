podTemplate(label: 'slave', containers: [
        containerTemplate(
                image: 'docker', name: 'docker', privileged: true,  workingDir: '/home/jenkins', command: 'cat', ttyEnabled: true),
        containerTemplate(
                image: 'maven', name: 'maven', privileged: true,  workingDir: '/home/jenkins', command: 'cat', ttyEnabled: true),
        containerTemplate(
                image: 'tutum/curl', name: 'curl', privileged: true,  workingDir: '/home/jenkins', command: 'cat', ttyEnabled: true)
],

        volumes: [
                hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock')
        ]) {

    node('slave') {

        stage('Checkout') {
            checkout(
                    [$class: 'GitSCM',
                     branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false,
                     extensions: [[$class: 'CleanBeforeCheckout']], submoduleCfg: [],
                     userRemoteConfigs: [[url: 'https://github.com/shefeg/DevOps028final.git']]]
            )
        }

        container ('maven') {
            stage('Build package') {
                sh "mvn clean package"
                archive 'target/*.jar'
            }
        }

        container ('docker') {

            stage('Build and push Samsara and Postgres images to AWS ECR') {
                sh "set +x && docker login -u ${params.USERNAME} -p ${params.PASSWORD} https://455022533484.dkr.ecr.us-east-1.amazonaws.com"
                sh "docker build -f Dockerfile.app -t 455022533484.dkr.ecr.us-east-1.amazonaws.com/samsara:latest ."
                sh "docker build -f Dockerfile.db -t 455022533484.dkr.ecr.us-east-1.amazonaws.com/postgresdb:latest ."
                sh "docker push 455022533484.dkr.ecr.us-east-1.amazonaws.com/samsara:latest"
                sh "docker push 455022533484.dkr.ecr.us-east-1.amazonaws.com/postgresdb:latest"

                try {
                    sh "docker rmi `docker images -q -f dangling=true`"
                } catch (Exception e) {
                    return true
                }
            }

            container ('curl') {

                stage('Configure kubectl tool') {
                    sh "curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl"
                    sh "chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl"
                    sh "mkdir -p ~/.kube"
                    sh "cp config ~/.kube/config && kubectl cluster-info"
                }

                stage('Apply updates to Kubernetes cluster when ready') {
                    sh "kubectl apply -f postgres-deployment.yaml"
                    sh "kubectl apply -f samsara-deployment.yaml && kubectl set image deployment samsara-deployment samsara=455022533484.dkr.ecr.us-east-1.amazonaws.com/samsara --record"
                }

                stage('Check if application is reachable on the Loadbalancer') {
                    timeout(time: 10, unit: 'MINUTES') {
                        sh "until \$(curl -sSf http://`kubectl describe svc samsara | grep \"LoadBalancer Ingress:\" | cut -d':' -f2 | tr -d ' '`:9000/login > /dev/null); do sleep 10; done"
                    }
                }
            }
        }
    }
}
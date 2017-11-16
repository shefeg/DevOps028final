import java.net.*;
node('master') {

    parameters {
        string(name: 'MAVEN_OPTS', defaultValue: '-Djava.awt.headless=true', description: 'Options for Maven')
        string(name: 'KOPS_CLUSTER_NAME', defaultValue: 'aikubernetes.k8s.local')
        string(name: 'KOPS_CLUSTER_S3_STATE', defaultValue: 's3://aikubernetes-k8s-local-state-store')
    }

    stage('Checkout') {
        checkout(
                [$class: 'GitSCM',
                 branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false,
                 extensions: [[$class: 'CleanBeforeCheckout']], submoduleCfg: [],
                 userRemoteConfigs: [[url: 'https://github.com/shefeg/DevOps028final.git']]]
        )
    }

    stage('Build application') {
        def mvn_version = 'M3'
        withEnv( ["PATH+MAVEN=${tool mvn_version}/bin"] ) {
            sh "mvn clean package"
        }
    }

    stage('Create Artifact') {
        archive 'target/*.jar'
    }

    stage('Push Samsara and Postgres images to private Docker registry') {
        app = docker.build("samsara", "-f Dockerfile.app .")
        db = docker.build("postgresdb", "-f Dockerfile.db .")
        docker.withRegistry("http://34.238.146.160:32003") {
            app.push("latest")
            db.push("latest")
        }
        try {
            sh "docker rmi `docker images -q -f dangling=true`"
        } catch (Exception e) {
            return true
        }
    }

    stage('Configure kubectl tool') {
        sh "curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl"
        sh "chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl"
        sh "mkdir -p ~/.kube"
        sh "cp config ~/.kube/config && kubectl cluster-info"
    }

    stage('Apply updates to Kubernetes cluster when ready') {
        sh "kubectl apply -f postgres-deployment.yaml"
        sh "kubectl apply -f samsara-deployment.yaml && kubectl set image deployment samsara-deployment samsara=34.238.146.160:32003/samsara --record"
    }

    stage('Check if application is reachable on the Loadbalancer') {
        timeout(time: 10, unit: 'MINUTES') {
            sh "until \$(curl -sSf http://`kubectl describe svc samsara | grep \"LoadBalancer Ingress:\" | cut -d':' -f2 | tr -d ' '`:9000/login > /dev/null); do sleep 10; done"
        }
    }
}
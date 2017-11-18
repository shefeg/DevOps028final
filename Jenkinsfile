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
                sh "docker login -u AWS -p eyJwYXlsb2FkIjoiNjl3a2hIU1VabmFrV2JqcU52VXppZjRabllWeUhHUkp1R0JOZVJ2dHg3Tkpyc0RzKzVOOHhSM0hiTWpYZ2I4MzhsbFM4RXRad0dQbWVhRDBpdzgxVHpiTyt2dHNsK05CUURSWVZsWFBIUXBFV2dlSXZFUURsWnEzM2dIMGozUlhWWDU1akZJYlV1WkxDdUh4Y2U5U0VoaDdNM3FPVWkrdG5QMkJCejNnN21QRUFlTFNBK0hXaFE4TWx2dS9NaEJDQWxHdlFZbDlQb0tyNE9oU21lWkRyT0xWTm5SRmYzeDFheHBlY3d1b3d6a25xRHB3WXBCTzF3ZVJMN0VFdVlRbnE5SkUvOFkzRSsyYmpRVWdCemVhNUVCTU9CeS83aXVJeVdLWllBRDRjOHNKRk94Vlh6MHdzSmtiUURnbXBjWjg4VzlJWHB3d291U3ZuU09BZkZJY3psMWlMSFVMTkczRktWU2FVMVRLblU4Y1NoS2hEN0QreGFYckdndlU1S3pvZys1dEFacGpWUG10Q0x3a3RoMVc3Z1hiMnU1b2x5azJZN2diMmN6NWp1eGtZUnRZZ2JlK2xxSTRLWjdhSVdTaWxxcmFRWWpVditKdGJ2SG9XWVhXbUwyYUdRL3hqQjdMTitTblhpb2cyclk0MTJQb0ozS3lZbUt0Qm4xckxiaHkybjZzRTNFbTZhVVNOQk5WanpnTEkyTHhNaWJkMWViWVppb2tkRjI0cHl3Q1luM1RwR3ZCSkxkNnprNi9iQXFPaG54TDU5dk1OOTlIN2hadWJuaU15M2JXemlYRExNTHZ5MDlMT3JNbEhGNGZ5a1lvamRlcnVNc3VaNldZSDYvNjk2RFhwdzU2MXQyMzMyM1graG93T3lLQTlHTTdlQmNxeVBUeUN3SVcxaUdwRE5oekRudHZGZ0ZoNDF0TnA3dmZKYW5RY3JUVEdCWC91SXZJUk9hNWllNm1WcG4wUE0xbnBuRnhrQXpBeDFBMlQ4ZWtFOGM5bVloSTI3ZGJOQjFSVnl6NWVmRUpDSEZWYWUvRHkrcy9lOW5GbDlTR2g3d25HcmV6ZnpUMEtQZUd1ZlNuelI3TWJTTCtZbHhaYnhrdnRubDFtTkdNWlp5VmJ4cVhCK1ZHZUlQMmJJNnFjU0FidnVvNEVra2dmUzZEeFp5SUNkL2dWT0lVWGRhTkFhQm1wQmh5b05Kcjg2VGlTMzR6aFpkaDBwZmhoajZYR3U2ZkxZbmNnaUpEeTBmRXhOVTRNNXowSE94UlB3MHMxMG9sQ04yZHNzMDNXRVpDSlVPbUxHaXd3ZG9oRW9YY2hLc0ZzNEkwY0hsYndQamlsZjFQMFJXV2ZmK2RsUjNCRUtxUXA2NXRYVlhLM2gwdlU1T1Erd0dBdkw4cXRmQUZMVXhFZmp3MnhUZENodndYa3ZjVU5mOVBCYnQ5ZEhmODZKejVOVTRqNkg5QVcrV3JxaDBrYXpWWFZFcGlURFFiV2JjUzVqWWM4R2o4IiwiZGF0YWtleSI6IkFRRUJBSGh3bTBZYUlTSmVSdEptNW4xRzZ1cWVla1h1b1hYUGU1VUZjZTlScTgvMTR3QUFBSDR3ZkFZSktvWklodmNOQVFjR29HOHdiUUlCQURCb0Jna3Foa2lHOXcwQkJ3RXdIZ1lKWUlaSUFXVURCQUV1TUJFRURGOTZZVGRQR0dlZVhwRkxBd0lCRUlBN3RjcTVQNVFoNldxZW5RT1U4alhBRlZMckhWZHl1RExyWE83bzZ2RTVtWnpaSktVTHZjckEyT2lISnZ0RThhT1RqRUZNV2dKeWlHQVZBQ1U9IiwidmVyc2lvbiI6IjIiLCJ0eXBlIjoiREFUQV9LRVkiLCJleHBpcmF0aW9uIjoxNTExMDM2NzEwfQ== https://455022533484.dkr.ecr.us-east-1.amazonaws.com"
                sh "docker build -f Dockerfile.app -t 455022533484.dkr.ecr.us-east-1.amazonaws.com/samsara:latest ."
                sh "docker build -f Dockerfile.db -t 455022533484.dkr.ecr.us-east-1.amazonaws.com/postgresdb:latest ."
                sh "docker push 455022533484.dkr.ecr.us-east-1.amazonaws.com/samsara:latest"
                sh "docker push 455022533484.dkr.ecr.us-east-1.amazonaws.com/postgresdb:latest"

                try {
                    sh "docker rmi `docker images -q -f dangling=true`"
                } catch (Exception e) {
                    return true
                }
            }}

        container ('curl') {

            stage('Configure kubectl tool') {
                sh "curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl"
                sh "chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl"
                sh "mkdir -p ~/.kube"
                sh "cp config ~/.kube/config && kubectl cluster-info"
                try {
                    sh "docker rmi `docker images -q -f dangling=true`"
                } catch (Exception e) {
                    return true
                }
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
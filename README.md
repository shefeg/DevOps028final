# Samsara

Auth service

## What you'll need
- JDK 1.7+
- Maven 3+

## Stack
- Java
- Spring Boot
- FreeMarker

## Run
`java -jar Samsara-1.5.8.RELEASE.jar`

##Deploy Samsara service with Kubernetes in AWS
###Prerequisites:
- Kops _https://github.com/kubernetes/kops_
- Install and Set Up kubectl _https://kubernetes.io/docs/tasks/tools/install-kubectl_

###Deploy steps:
**1. Spin up Kops cluster in AWS** \
git clone https://github.com/shefeg/DevOps028final.git \
cd DevOps028final \
kops replace --name aikubernetes.k8s.local --state=s3://aikubernetes-k8s-local-state-store -f kops-full-cluster.yaml \
kops update cluster --name aikubernetes.k8s.local --state=s3://aikubernetes-k8s-local-state-store --yes \
**2. Spin up Jenkins deployment** \
kubectl apply -f jenkins-deployment.yaml \
**3. Start Jenkins pipeline job in Jenkins server** \
**4. Open Samsara application via browser using Loadbalancer URL**
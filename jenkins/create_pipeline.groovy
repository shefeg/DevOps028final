def cmd = "java -jar /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080/ -auth alexey:Ins1ght create-job build_application_4 < /var/jenkins_home/build_application.xml";
ProcessBuilder pb = new ProcessBuilder("bash", "-c", cmd);
pb.start();
import jenkins.model.*

def jobName = "build_application"
def configXml = "/var/jenkins_home/build_application.xml"

def xmlStream = new ByteArrayInputStream( configXml.getBytes() )

//Jenkins.instance.createProjectFromXML(jobName, xmlStream)
Job createPipeline {
    parent.createProjectFromXML(jobName, xmlStream)
}
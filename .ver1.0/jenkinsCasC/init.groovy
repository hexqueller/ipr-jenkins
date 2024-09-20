import jenkins.model.*
import hudson.slaves.*
import jenkins.slaves.JnlpSlaveAgentProtocol.*

def agentName = "jnlp-agent"
def agentLabel = "jnlp-agent"
def agentRemoteFS = "/home/jenkins/agent"

def slave = new DumbSlave(agentName, agentRemoteFS, agentLabel)
slave.setLauncher(JnlpSlaveAgentProtocol.class.newInstance())
Jenkins.instance.addNode(slave)

println "Agent ${agentName} added with secret: ${slave.getComputer().getJnlpMac()}"

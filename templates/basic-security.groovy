import hudson.security.*
import jenkins.model.*

def instance = Jenkins.getInstance()

println "--> Checking if security has been set already"

if (!instance.isUseSecurity()) {
    println "--> creating local user 'admin'"

    def hudsonRealm = new HudsonPrivateSecurityRealm(false)
    hudsonRealm.createAccount('{{ jenkins_master_admin_user }}', '{{ jenkins_master_admin_password }}')
    instance.setSecurityRealm(hudsonRealm)

    def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
    instance.setAuthorizationStrategy(strategy)
    instance.save()
}

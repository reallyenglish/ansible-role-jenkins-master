import groovy.json.*
import hudson.model.*
import jenkins.model.*

def plugins = jenkins.model.Jenkins.instance.getPluginManager().getPlugins()


def Jenkins jenkins_instance = Jenkins.getInstance()
def Descriptor desc
desc = jenkins_instance.getDescriptor('jenkins.plugins.hipchat.HipChatNotifier')

println ""

println desc
println desc.metaClass.methods*.name.sort().unique()

// [calcAutoCompleteSettings, calcFillSettings, configure, doCheckSendAs, doFillCardProviderItems, doFillCredentialIdItems, doHelp, doSendTestNotification, equals, filter, find, findByDescribableClassName, findById, getCardProvider, getCategory, getCheckMethod, getCheckUrl, getClass, getCompleteJobMessageDefault, getConfigPage, getCredentialId, getCurrentDescriptorByNameUrl, getDefaultNotifications, getDescriptorFullUrl, getDescriptorUrl, getDisplayName, getGlobalConfigPage, getGlobalPropertyType, getHelpFile, getId, getJsonSafeClassName, getKlass, getPropertyType, getPropertyTypeOrDie, getRoom, getSendAs, getServer, getStartJobMessageDefault, getT, getToken, hashCode, isApplicable, isInstance, isMatrixProject, isSubTypeOf, isV2Enabled, load, newInstance, newInstancesFromHeteroList, notify, notifyAll, save, setCardProvider, setCredentialId, setDefaultNotifications, setRoom, setSendAs, setServer, setToken, setV2Enabled, toArray, toList, toMap, toString, wait]

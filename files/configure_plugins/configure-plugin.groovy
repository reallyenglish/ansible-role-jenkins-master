import jenkins.model.*
import groovy.json.*
import hudson.model.*

def class_name(name) {
  // map of pluginname:classname
  // there is no way to find the descriptor name from the plugin name
  // without reading the source code.
  def map = ['hipchat':'HipChatNotifier']
  return map[name] ? map[name] : ''
}

def get_descriptor(name) {
  def Jenkins jenkins_instance = Jenkins.getInstance()
  def descriptor_name = "jenkins.plugins.${name}.${class_name(name)}"
  return jenkins_instance.getDescriptor(descriptor_name)
}

def plugins() {
  return jenkins.model.Jenkins.instance.pluginManager.plugins
}

def find_plugin(name) {
  if (get_descriptor(name) != null) {
    return get_descriptor(name)
  }
  else {
    return plugins().find { it.shortName == name }.plugin
  }
}

def all_methods(object) {
  return object.metaClass.methods*.name.sort().unique()
}

def find_intersect(list, prefix1, prefix2) {
  stem1 = list.findAll { it ==~ "^${prefix1}.*" }
              .collect { it.replaceFirst(prefix1, "") }
  stem2 = list.findAll { it ==~ "^${prefix2}.*" }
              .collect { it.replaceFirst(prefix2, "") }
  return stem1.toSet().intersect(stem2.toSet())
}

def configurables(plugin) {
  return find_intersect(all_methods(plugin), "get", "set")
}

def flags(plugin) {
  return find_intersect(all_methods(plugin), "is", "set")
}

def get_config(plugin) {
  def config = [:]
  configurables(plugin).each {
    value = plugin."get$it"()
    config["${it}"] = value
  }
  flags(plugin).each {
    value = plugin."is$it"()
    config["${it}"] = value
  }
  return config
}

def set_config(plugin, config_json) {
  def new_config = new JsonSlurper().parseText(config_json)
  def current_config = get_config(plugin)
  def changed_config = [:]
  new_config.each {
    key = it.key
    val = it.value
    if (current_config.containsKey(key) && (val != current_config[key])) {
      plugin."set$key"(val)
      changed_config[key] = val
    }
  }
  if (changed_config.size() > 0) {
    plugin.save()
    println new JsonBuilder(changed_config)
  }
}

def usage() {
  println "configure-plugins.groovy (get|set) pluginname [json]"
}

if (args.length > 1) {
  plugin_name = args[1]
  switch (args[0]) {
    case "get" :
      println new JsonBuilder(get_config(find_plugin(plugin_name)))
      break
    case "set" :
      if (args.length > 2) {
        set_config(find_plugin(plugin_name), args[2])
      }
      else {
        usage()
      }
      break
    default :
      usage()
      break
  }
}
else {
  usage()
}
// vim: ft=groovy

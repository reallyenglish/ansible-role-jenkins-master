import jenkins.model.*
import groovy.json.*

def plugins() {
  return jenkins.model.Jenkins.instance.pluginManager.plugins
}

def find_plugin(name) {
  return plugins().find { it.shortName == name }.plugin
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
  def json = new JsonBuilder()
  def config = [:]
  configurables(plugin).each {
    value = plugin."get$it"()
    config["${it}"] = value
  }
  flags(plugin).each {
    value = plugin."is$it"()
    config["${it}"] = value
  }
  json config
  return json
}

def set_config(plugin, config) {
}

def usage() {
  println "configure-plugins.groovy (get|set) pluginname [json]"
}

if (args.length > 1) {
  plugin_name = args[1]
  switch (args[0]) {
    case "get" :
      println get_config(find_plugin(plugin_name))
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

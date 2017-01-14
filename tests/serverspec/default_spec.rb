require "spec_helper"
require "serverspec"

package = "jenkins"
service = "jenkins"
user    = "jenkins"
group   = "jenkins"
ports   = [ 8080 ]
log_file = "/var/log/jenkins/jenkins.log"
home    = "/var/lib/jenkins"
cli     = "/usr/bin/jenkins-cli.jar"
url     = "http://127.0.0.1:8080/jenkins"
plugins = [ "git", "hipchat", "matrix-project" ]

case os[:family]
when "freebsd"
  ports   = [ 8180 ]
  home    = "/usr/local/jenkins"
  cli     = "/usr/local/bin/jenkins-cli.jar"
  url     = "http://127.0.0.1:8180/jenkins"
  log_file = "/var/log/jenkins.log"
end

describe package(package) do
  it { should be_installed }
end 

describe file(log_file) do
  it { should be_file }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/jenkins") do
    it { should be_file }
    its(:content) { should match(/^jenkins_java_opts="#{ Regexp.escape("-Djava.awt.headless=true") } #{ Regexp.escape("-Djenkins.install.runSetupWizard=false") }"$/) }
    its(:content) { should match(/^jenkins_args="--webroot=#{ Regexp.escape("/usr/local/jenkins/war") } --httpPort=8180 --prefix=\/jenkins"$/) }
  end

when "centos"
  describe file("/etc/sysconfig/jenkins") do
    it { should be_file }
    its(:content) { should match(/^JENKINS_HOME="#{ Regexp.escape(home) }"$/) }
    its(:content) { should match(/^JENKINS_USER="jenkins"$/) }
    its(:content) { should match(/^JENKINS_JAVA_OPTIONS="#{ Regexp.escape("-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false") }"$/) }
    its(:content) { should match(/^JENKINS_PORT="8080"$/) }
    its(:content) { should match(/^JENKINS_ARGS="--prefix=\/jenkins\s+"$/) }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

describe file(cli) do
  it { should be_file }
  it { should be_mode 755 }
end

describe file("#{ home }/init.groovy.d") do
  it { should be_directory }
  it { should be_mode 755 }
end

describe file("#{ home }/updates") do
  it { should be_directory }
  it { should be_mode 755 }
end

describe file("#{ home }/updates/default.json") do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

plugins.each do |p|
  describe file("#{ home }/plugins/#{ p }.jpi") do
    it { should be_file }
  end
end

describe command("java -jar #{ cli } -s #{ url } list-plugins") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^git\s+/) }
  its(:stdout) { should match(/^hipchat\s+/) }
  its(:stderr) { should match(/^$/) }
end

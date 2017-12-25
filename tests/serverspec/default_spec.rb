require "spec_helper"
require "serverspec"

package = "jenkins"
service = "jenkins"
user    = "jenkins"
group   = "jenkins"
port    = 8280
log_file = "/var/log/jenkins/jenkins.log"
home    = "/var/lib/jenkins"
cli     = "/usr/bin/jenkins-cli.jar"
url     = "http://127.0.0.1:#{port}/jenkins"
plugins = %w[git hipchat matrix-project ssh-slaves]
jenkins_java_opts =
  "-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false"
jenkins_args =
  "\"--prefix=/jenkins --webroot=/usr/local/jenkins/war --httpPort=#{port}\""
ssh_passphrase = "passphrase"
ssh_checksum =
  "2048 SHA256:L5L3cuQABEnrDP+xNRz9yzAtU9cicM9O0rJTpkMWtpE\
 #{user}@#{host_inventory['fqdn']} (RSA)"
nodes = [
  { name: "slave1",
    remotefs: "/usr/local/jenkins",
    host: "slave1.example.com",
    labels: %w[label1 label2] },
  { name: "slave2",
    remotefs: "/usr/local/jenkins",
    host: "192.168.33.13" }
]

case os[:family]
when "freebsd"
  home    = "/usr/local/jenkins"
  cli     = "/usr/local/bin/jenkins-cli.jar"
  log_file = "/var/log/jenkins.log"
  # TODO: workaround for #31
  # remove this when the newer package which fixes the issue is released
  plugins = %w[git-client hipchat matrix-project ssh-slaves]
when "ubuntu"
  jenkins_args =
    "--webroot=/var/cache/$NAME/war --httpPort=$HTTP_PORT\
 --prefix=/jenkins"
  if Gem::Version.new(os[:release]) <= Gem::Version.new("14.04")
    ssh_checksum =
      "2048 27:e7:34:1a:33:48:c5:16:df:1c:ce:dc:80:78:39:5f\
  #{user}@#{host_inventory['fqdn']} (RSA)"
  end
when "redhat"
  if Gem::Version.new(os[:release]) <= Gem::Version.new("7.3.1611")
    ssh_checksum =
      "2048 27:e7:34:1a:33:48:c5:16:df:1c:ce:dc:80:78:39:5f\
  #{user}@#{host_inventory['fqdn']} (RSA)"
  end
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
    its(:content) do
      should match(
        /^jenkins_java_opts="#{Regexp.escape(jenkins_java_opts)}"$/
      )
    end
    its(:content) do
      should match(
        /^jenkins_args=#{Regexp.escape(jenkins_args)}$/
      )
    end
  end
when "ubuntu"
  describe file("/etc/default/jenkins") do
    it { should be_file }
    its(:content) do
      should match(
        /^JAVA_ARGS="#{ Regexp.escape(jenkins_java_opts) }"$/
      )
    end
    its(:content) { should match(/^HTTP_PORT="#{port}"$/) }
    its(:content) do
      should match(
        /^JENKINS_ARGS="#{Regexp.escape(jenkins_args)}\s*"$/
      )
    end
  end
when "redhat"
  describe file("/etc/sysconfig/jenkins") do
    it { should be_file }
    its(:content) { should match(/^JENKINS_HOME="#{ Regexp.escape(home) }"$/) }
    its(:content) { should match(/^JENKINS_USER="jenkins"$/) }
    its(:content) do
      should match(
        /^JENKINS_JAVA_OPTIONS="#{ Regexp.escape(jenkins_java_opts) }"$/
      )
    end
    its(:content) { should match(/^JENKINS_PORT="#{port}"$/) }
    its(:content) { should match(%r{^JENKINS_ARGS="--prefix=/jenkins\s+"$}) }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

describe port(port) do
  it { should be_listening }
end

describe file(cli) do
  it { should be_file }
  it { should be_mode 755 }
end

describe file("#{home}/init.groovy.d") do
  it { should be_directory }
  it { should be_mode 755 }
end

describe file("#{home}/.ssh") do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file("#{home}/.ssh/id_rsa") do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file("#{home}/.ssh/id_rsa.pub") do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe command("ssh-keygen -lf #{home}/.ssh/id_rsa") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^#{Regexp.escape(ssh_checksum)}$/) }
  its(:stderr) { should match(/^$/) }
end

describe command("ssh-keygen -lf #{home}/.ssh/id_rsa.pub") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^#{Regexp.escape(ssh_checksum)}$/) }
  its(:stderr) { should match(/^$/) }
end

describe command(
  "ssh-keygen -p -P #{ssh_passphrase} -N #{ssh_passphrase} -f\
 #{home}/.ssh/id_rsa"
) do
  its(:exit_status) { should eq 0 }
end

describe file("#{home}/updates") do
  it { should be_directory }
  it { should be_mode 755 }
end

describe file("#{home}/updates/default.json") do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

plugins.each do |p|
  describe file("#{home}/plugins/#{p}.jpi") do
    it { should be_file }
  end
end

describe command("java -jar #{cli} -s #{url} list-plugins") do
  its(:exit_status) { should eq 0 }
  plugins.each do |p|
    its(:stdout) { should match(/^#{ p }\s+/) }
  end
  its(:stderr) { should match(/^$/) }
end

describe command(
  "java -jar #{cli} -s #{url} list-credentials\
  'SystemCredentialsProvider::SystemContextResolver::jenkins'\
   --username admin --password password"
) do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^[0-9a-f]+[-0-9a-f]+[0-9a-f]+\s+#{user}$/) }
end

describe file("#{home}/credentials.xml") do
  its(:content) { should match(%r{<passphrase>.*</passphrase>$}) }
end

nodes.each do |node|
  describe command(
    "java -jar #{cli} -s #{url} get-node #{node[:name]}\
     --username admin --password password"
  ) do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(%r{<name>#{node[:name]}</name>}) }
    its(:stdout) { should match(%r{<remoteFS>#{node[:remotefs]}</remoteFS>}) }
    its(:stdout) { should match(%r{<host>#{node[:host]}</host>}) }
    its(:stdout) do
      should match(
        %r{<credentialsId>[0-9a-f]+[-0-9a-f]+[0-9a-f]+</credentialsId>}
      )
    end
    if node.key?(:labels)
      node[:labels].each do |label|
        its(:stdout) { should match(%r{<label>.*#{label}.*</label>}) }
      end
    else
      its(:stdout) { should match(%r{<label></label>}) }
    end
    its(:stderr) { should match(/^$/) }
  end
end

if os[:family] == "freebsd"
  describe file("/usr/local/etc/rc.d/jenkins") do
    its(:content) do
      should match(/#{Regexp.escape(">> ${jenkins_log_file}")}/)
    end
    its(:content) do
      should_not match(/[^>]#{Regexp.escape("> ${jenkins_log_file}")}/)
    end
  end
end

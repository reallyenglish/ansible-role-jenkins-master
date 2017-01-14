require 'spec_helper'
require 'serverspec'

package = 'jenkins-master'
service = 'jenkins-master'
config  = '/etc/jenkins-master/jenkins-master.conf'
user    = 'jenkins-master'
group   = 'jenkins-master'
ports   = [ PORTS ]
log_dir = '/var/log/jenkins-master'
db_dir  = '/var/lib/jenkins-master'

case os[:family]
when 'freebsd'
  config = '/usr/local/etc/jenkins-master.conf'
  db_dir = '/var/db/jenkins-master'
end

describe package(package) do
  it { should be_installed }
end 

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape('jenkins-master') }
end

describe file(log_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(db_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

case os[:family]
when 'freebsd'
  describe file('/etc/rc.conf.d/jenkins-master') do
    it { should be_file }
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

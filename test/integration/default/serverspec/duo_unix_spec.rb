require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS


RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe "SSH Daemon" do

  it "is listening on port 22" do
    expect(port(22)).to be_listening
  end

  it "has a running server of openssh" do
    expect(service('ssh')).to be_running
  end

  it "should disable ssh TCP forwarding" do
    expect(file('/etc/ssh/sshd_config')).to contain('AllowTcpForwarding no')
  end

  it "should disable ssh Tunnelling" do
    expect(file('/etc/ssh/sshd_config')).to contain('PermitTunnel no')
  end

  it "should enable login_duo ForceCommand in sshd_config" do
    expect(file('/etc/ssh/sshd_config')).to contain('ForceCommand /usr/sbin/login_duo')
  end

  if os[:release] == '12.04' 
    it "should install the duo_unix package" do
      expect(package('duo-unix')).to be_installed
    end
  end
end

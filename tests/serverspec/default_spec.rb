require "spec_helper"
require "serverspec"

package = "acme_client"
service = "acme_client"
config  = "/etc/acme_client/acme_client.conf"
user    = "acme_client"
group   = "acme_client"
ports   = [PORTS]
log_dir = "/var/log/acme_client"
db_dir  = "/var/lib/acme_client"

case os[:family]
when "freebsd"
  config = "/usr/local/etc/acme_client.conf"
  db_dir = "/var/db/acme_client"
end

describe package(package) do
  it { should be_installed }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape("acme_client") }
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
when "freebsd"
  describe file("/etc/rc.conf.d/acme_client") do
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

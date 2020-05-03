require "spec_helper"
require "serverspec"

config  = "/etc/acme-client.conf"
key_dir = "/etc/acme"
default_group = "wheel"

describe file key_dir do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by "root" }
  it { should be_grouped_into default_group }
  it { should be_mode 700 }
end

describe file config do
  it { should exist }
  it { should be_file }
  it { should be_owned_by "root" }
  it { should be_grouped_into default_group }
  it { should be_mode 644 }
  its(:content) { should match(/Managed by ansible/) }
  its(:content) { should match(/^authority letsencrypt {$/) }
  its(:content) { should match(/^domain example\.org {$/) }
  its(:content) { should match(/^domain example\.net {$/) }
end

describe cron do
  it { should have_entry "45 8 * * * acme-client -f /etc/acme-client.conf -vv example.org" }
  it { should have_entry "45 9 * * * acme-client -f /etc/acme-client.conf -vv example.net" }
end

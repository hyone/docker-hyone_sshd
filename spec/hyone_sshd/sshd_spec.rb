require 'spec_helper'

describe package('openssh-server') do
  it { should be_installed }
end

describe port(22) do
  it { should be_listening }
end

describe file('/root/.ssh') do
  it { should be_directory }
  it { should be_mode 700 }
end

describe file('/root/.ssh/authorized_keys') do
  it { should be_file }
  it { should be_mode 600 }
end

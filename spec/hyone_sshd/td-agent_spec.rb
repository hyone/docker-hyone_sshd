require 'spec_helper'

describe package('td-agent') do
  it { should be_installed }
end

describe port(24220) do
  it { should be_listening }
end
describe port(24224) do
  it { should be_listening.with('udp') }
end
describe port(24224) do
  it { should be_listening.with('tcp') }
end

require 'serverspec'
require 'pathname'
require 'net/ssh'
require 'uri'
require 'docker'

include SpecInfra::Helper::Ssh
include SpecInfra::Helper::DetectOS


RSpec.configure do |c|
  containers = []

  docker_host =
    if ENV['DOCKER_HOST']
      begin
        URI.parse(ENV['DOCKER_HOST'])
      rescue URI::InvalidURIError
        URI.parse('localhost:4243')
      end
    end

  c.before :all do
    block = self.class.metadata[:example_group_block]
    if RUBY_VERSION.start_with?('1.8')
      file = block.to_s.match(/.*@(.*):[0-9]+>/)[1]
    else
      file = block.source_location.first
    end
    host = File.basename(Pathname.new(file).dirname)
    if c.host != host
      if docker_host
        Docker.url = "http://#{docker_host.host}:#{docker_host.port}/"
      end

      container = Docker::Container.create(
        Image: host.sub('_', '/'),
        User: 'root',
        # Entrypoint: ['/usr/sbin/sshd'],
        # Cmd: ['-D'],
        # ExposedPorts: {'22/tcp' => {}},
      ).start(
        PortBindings: {
          '22/tcp' => [{HostIp: '0.0.0.0'}]
        },
        Privileged: true
      )
      sleep 5
      containers << container

      c.ssh.close if c.ssh
      c.host  = host
      options = {
        keys: [File.expand_path('~/.ssh/docker-dev')],
        port: container.json['HostConfig']['PortBindings']['22/tcp'][0]['HostPort'].to_i
      }
      c.ssh = Net::SSH.start(
        docker_host ? docker_host.host : '127.0.0.1',
        'root',
        options
      )
    end
  end

  c.after(:suite) do
    ## Kill and delete containers
    containers.each {|container| container.kill.delete }
  end
end

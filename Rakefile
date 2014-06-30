require 'rake'
require 'my_docker_rake/tasks'
require 'rspec/core/rake_task'
include MyDockerRake::Utilities


RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

MyDockerRake::Tasks.new do |c|
  c.containers = [
    {
      name: 'hyone.sshd',
      image: 'hyone/sshd',
      ports: [22, 2812, 24220, 24224, '24224/udp'],
      options: '--privileged'
    }
  ]

  unless c.containers.all? { |c| has_image?(c[:image]) }
    task('spec').prerequisites << 'docker:build'
  end
end

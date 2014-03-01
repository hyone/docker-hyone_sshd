FROM hyone/ubuntu:latest
MAINTAINER hyone "hyone.development@gmail.com"

## Install

RUN apt-get install -q -y \
  openssh-server \
  monit ; \
  curl -L http://toolbelt.treasuredata.com/sh/install-ubuntu-precise.sh | sh ; \
  /usr/lib/fluent/ruby/bin/gem install \
    fluent-plugin-record-modifier  \
    fluent-plugin-route

# monit and td-agent settings
ADD td-agent/td-agent.conf /etc/td-agent/td-agent.conf
ADD monit/monitrc /etc/monit/monitrc
ADD monit/conf.d  /etc/monit/conf.d
ADD init.d/ssh    /etc/init.d/ssh
RUN mkdir -p /etc/td-agent/conf.d ; \
    mkdir -p /var/log/td-agent ; \
    chown root:root /etc/monit/monitrc ; \
    chmod 700 /etc/monit/monitrc ; \
    chown root:root /etc/init.d/ssh ; \
    chmod +x /etc/init.d/ssh

# ssh settings
ADD ./docker-dev.pub   /root/.ssh/authorized_keys
RUN chmod 700 /root/.ssh ; \
    chmod 600 /root/.ssh/authorized_keys ; \
    chown root:root -R /root/.ssh ; \
    mkdir -p /var/run/sshd ; \

## Command

CMD ["/usr/bin/monit", "-I"]

# sshd
EXPOSE 22
# monit
EXPOSE 2812
# for fluentd
EXPOSE 24220 24224

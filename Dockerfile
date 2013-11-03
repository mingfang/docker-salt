FROM ubuntu
 
RUN echo 'deb http://archive.ubuntu.com/ubuntu precise main universe' > /etc/apt/sources.list && \
    echo 'deb http://archive.ubuntu.com/ubuntu precise-updates universe' >> /etc/apt/sources.list && \
    apt-get update

#Prevent daemon start during install
RUN	echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

#Supervisord
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor && \
	mkdir -p /var/log/supervisor
CMD ["/usr/bin/supervisord", "-n"]

#SSHD
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server && \
	mkdir /var/run/sshd && \
	echo 'root:root' |chpasswd

#Utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim less net-tools inetutils-ping curl git telnet nmap socat

RUN echo 'deb http://ppa.launchpad.net/saltstack/salt/ubuntu precise main' > /etc/apt/sources.list.d/saltstack.list && \
    wget -q -O- "http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0x4759FA960E27C0A6" | apt-key add - && \
    apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y salt-master salt-minion salt-syndic

RUN apt-get install -y python-pip gcc python-dev libevent-dev
RUN pip install -U halite && \
    pip install CherryPy

ADD . /docker-salt
RUN cd /docker-salt && \
    cp --backup master.conf /etc/salt/master && \
    cp --backup minion.conf /etc/salt/minion && \
    cp supervisord-salt.conf /etc/supervisor/conf.d

RUN salt-master -d &&  salt-minion -d && sleep 3 && \
    salt-key -A -y

#Halite User
RUN useradd admin && \
    echo "admin:admin" | chpasswd

EXPOSE 22 8080


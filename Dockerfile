FROM ubuntu
 
RUN apt-get update

#Runit
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y runit 
CMD /usr/sbin/runsvdir-start

#SSHD
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server &&	mkdir -p /var/run/sshd && \
    echo 'root:root' |chpasswd

#Utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim less net-tools inetutils-ping curl git telnet nmap socat dnsutils netcat tree htop unzip sudo

#Salt Repo
RUN echo 'deb http://ppa.launchpad.net/saltstack/salt/ubuntu precise main' > /etc/apt/sources.list.d/saltstack.list && \
    wget -q -O- "http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0x4759FA960E27C0A6" | apt-key add - && \
    apt-get update

#Salt
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y salt-master salt-minion salt-syndic salt-ssh

#Munin
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y munin-node

#Docker client only
RUN wget -O /usr/local/bin/docker https://get.docker.io/builds/Linux/x86_64/docker-latest && \
    chmod +x /usr/local/bin/docker


#Preseed local master-minion
RUN cd /tmp && \
    salt-key --gen-keys=master-minion && \
    mkdir -p /etc/salt/pki/master/minions && \
    cp master-minion.pub /etc/salt/pki/master/minions/master-minion && \
    mkdir -p /etc/salt/pki/minion && \
    cp master-minion.pub /etc/salt/pki/minion/minion.pub && \
    cp master-minion.pem /etc/salt/pki/minion/minion.pem

#Halite
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python-pip gcc python-dev libevent-dev
RUN pip install -U halite && \
    pip install CherryPy

#Halite User
RUN useradd admin && \
    echo "admin:admin" | chpasswd

#Configuration
ADD . /docker

#Runit Automatically setup all services in the sv directory
RUN for dir in /docker/sv/*; do echo $dir; chmod +x $dir/run $dir/log/run; ln -s $dir /etc/service/; done

RUN cd /docker && \
    cp --backup -R salt/* /etc/salt && \
    mkdir -p /srv/salt && \
    cp -R srv/* /srv

ENV HOME /root
WORKDIR /root
EXPOSE 22 4506 8080


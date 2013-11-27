
Run Salt-Master, Salt-Minion, and Halite inside Docker
Also runs Kibana/Logstash and Graphite insider their own containers.

<img src="salt-grand-master.png"/>

####Halite/Salt UI

http://localhost:49080

####Kibana

http://localhost:49082

####Graphite

http://localhost:49880

###Instructions

1. run ```./build```
2. run ```./run```

###Boostrapping
Create/Edit /etc/salt/roster file
```
<id>:
    host: <host name or ip>
    user: <user with sudo>
    passwd: <pwd>
    sudo: True
```

Also, make sure /etc/sudoers file is configured for NOPASSWD
```%admin ALL=NOPASSWD: ALL```




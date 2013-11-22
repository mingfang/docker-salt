schedule:
  munin:
    function: munin.run
    args:
      - uptime,cpu,load,memory,df,iostat,if_eth0
    seconds: 10
    returner: carbon
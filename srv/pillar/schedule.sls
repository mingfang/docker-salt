schedule:
  munin:
    function: munin.run
    args:
      - uptime,cpu,load,memory
    seconds: 10
    returner: carbon
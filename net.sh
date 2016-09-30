#!/bin/bash
NPACK=1
TIMEOUT=10
URL="www.google.com"
INTERVAL=30
while true;
do
  ping -c $NPACK -W $TIMEOUT $URL 
  RETVAL=$?
  if [ $RETVAL -ne 0 ]; 
  then
    sudo service network-manager restart
    NEEDRELOAD=true
    i=0
    while [ $i -lt 3 ] ;
    do
      sleep $INTERVAL
      ping -c $NPACK -W $TIMEOUT $URL
      if [ $? -eq 0 ];
      then
        NEEDRELOAD=false
        break
      fi
      i=$[$i+1]
    done
    if $NEEDRELOAD
    then
      sudo modprobe -rv rtl8188ee;
      sudo modprobe -v rtl8188ee;
    fi
  fi
  sleep $INTERVAL
done


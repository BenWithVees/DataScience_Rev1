#!/bin/bash

#/etc/init.d/ssh start
export HOME=/root
mkdir /root/notebooks; cd /root/notebooks;
ipython notebook --profile=nbserver > /tmp/ipython.log 2>&1

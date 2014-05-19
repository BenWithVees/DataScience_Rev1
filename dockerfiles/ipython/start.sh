#!/bin/bash

echo "Starting iPython Node..."
CID_ipython=$(docker run -d --privileged --dns 127.0.0.1 -p 8888:8888 --name ipython -h ipython -i -t hwx/ipython)
IP_ipython=$(docker inspect --format "{{ .NetworkSettings.IPAddress }}" ipython)
echo "iPython started at $IP_ipython"

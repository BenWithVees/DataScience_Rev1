#!/bin/bash

echo "Starting IPython Notebook Node..."
CID_ipython=$(docker run -d --privileged --dns 127.0.0.1 -p 8888:8888 --name ipython -h ipython -i -t hwx/ipython_node)
IP_ipython=$(docker inspect --format "{{ .NetworkSettings.IPAddress }}" ipython)
echo "IPython Notebook Server Started at $IP_ipython"

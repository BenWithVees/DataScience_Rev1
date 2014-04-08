#!/bin/bash

# Build the Docker images

# Build hwx/hdp_node_base first
cd ./dockerfiles/hdp_node_base
x=$(docker images | grep -c  hwx/hdp_node_base)
if [ $x -eq 0 ]; then
	echo -e "\n*** Building hwx/hdp_node_base image... ***\n"
	docker build -t hwx/hdp_node_base .
	echo -e "\n*** Build of hwx/hdp_node_base complete! ***\n"
else
	echo -e "\n*** hwx/hdp_node_base image already built ***\n"
fi

# Build hwx/hdp_node
echo -e "\n*** Building hwx/hdp_node ***\n"
cd ../hdp_node
docker build -t hwx/hdp_node .
echo -e "\n*** Build of hwx/hdp_node complete! ***\n"

# Copy utility scripts into /root/scripts, which is already in the PATH
echo "Copying utility scripts..."
cp ../../scripts/* /root/scripts/

echo -e "\n*** The images have successfully been built for this classroom VM ***\n"

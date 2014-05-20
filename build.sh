#!/bin/bash

DS_DIR=$PWD

# Grab the HWX-University Dockerfiles
#cd /root
#git clone https://github.com/HortonworksUniversity/dockerfiles.git
cd /root/dockerfiles
git pull

# Build the Docker images

# Build hwx/hdp_node_base first
cd /root/dockerfiles/hdp_node_base
x=$(docker images | grep -c  hwx/hdp_node_base)
if [ $x == 0 ]; then
        echo -e "\n*** Building hwx/hdp_node_base image... ***\n"
        docker build -t hwx/hdp_node_base .
        echo -e "Build of hwx/hdp_node_base complete!"
else
        echo -e "\n*** hwx/hdp_node_base image already built ***\n"
fi

# Build hwx/hdp_node
echo -e "\n*** Building hwx/hdp_node ***\n"
cd /root/dockerfiles/hdp_node
docker build -t hwx/hdp_node .
echo -e "\n*** Build of hwx/hdp_node complete! ***\n"

# Build hwx/hdp_python_node
echo -e "\n*** Building hwx/hdp_python_node ***\n"
cd $DS_DIR/dockerfiles/hdp_python_node
docker build -t hwx/hdp_python_node .
echo -e "\n*** Build of hwx/hdp_python_node complete! ***\n"

# Build hwx/ipython_node
echo -e "\n*** Building hwx/ipython_node ***\n"
cd $DS_DIR/dockerfiles/ipython
docker build -t hwx/ipython_node .
echo -e "\n*** Build of hwx/ipython_node complete! ***\n"

#If this script is execute multiple times, untagged images get left behind
#This command removes any untagged Docker images
docker rmi $(docker images | grep '^<none>' | awk '{print $3}')

# Copy utility scripts into /root/scripts, which is already in the PATH
echo "Copying utility scripts..."
cp /root/dockerfiles/start_scripts/* /root/scripts/
cp /root/$1/scripts/* /root/scripts/


# Install JDK 7
apt-get -y install openjdk-7-jdk

# Fix a small issue with the yarn binary
mkdir -p /usr/java/default/bin/
ln –s /usr/bin/java /usr/java/default/bin/java


mkdir /home/train/labs
cp -R /root/$1/labs/* /home/train/labs
chown -R train:train /home/train/labs

# Setup environment variables
cp /root/scripts/setpath.sh /etc/profile.d/
chmod +x /etc/profile.d/setpath.sh
source /etc/profile.d/setpath.sh

#Install hadoop-client on the Ubuntu instance
wget http://public-repo-1.hortonworks.com/HDP/ubuntu12/2.x/hdp.list -O /etc/apt/sources.list.d/hdp.list
gpg --keyserver pgp.mit.edu --recv-keys B9733A7A07513CAD
gpg -a --export 07513CAD | apt-key add –
apt-get update
apt-get -y --force-yes install hadoop-client
cp /root/dockerfiles/hdp_node/configuration_files/core_hadoop/* /etc/hadoop/conf/

#Replace /etc/hosts with one that contains the Docker server names
cp /root/scripts/hosts /etc/


echo -e "\n*** The lab environment has successfully been built for this classroom VM ***\n"

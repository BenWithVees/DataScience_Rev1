#!/bin/bash

if [[ -z $1 ]];
then
  echo "Usage: $0 <class_version>"
  exit 1;
fi

DS_DIR=$1

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
cd /root/$DS_DIR/dockerfiles/hdp_python_node
docker build -t hwx/hdp_python_node .
echo -e "\n*** Build of hwx/hdp_python_node complete! ***\n"

# Build hwx/hdp_mahout_node
echo -e "\n*** Building hwx/hdp_mahout_node ***\n"
cd /root/$DS_DIR/dockerfiles/hdp_mahout_node
docker build -t hwx/hdp_mahout_node .
echo -e "\n*** Build of hwx/hdp_mahout_node complete! ***\n"

# Build hwx/hdp_spark_node
#echo -e "\n*** Building hwx/hdp_spark_node ***\n"
#cd /root/$DS_DIR/dockerfiles/hdp_spark_node
#docker build -t hwx/hdp_spark_node .
#echo -e "\n*** Build of hwx/hdp_spark_node complete! ***\n"

# Build hwx/ipython_node
echo -e "\n*** Building hwx/ipython_node ***\n"
cd /root/$DS_DIR/dockerfiles/ipython_node
docker build -t hwx/ipython_node .
echo -e "\n*** Build of hwx/ipython_node complete! ***\n"

#If this script is execute multiple times, untagged images get left behind
#This command removes any untagged Docker images
docker rmi -f $(docker images | grep '^<none>' | awk '{print $3}')

# Add/modify DS root directory in start scripts 
sed -i "/DS_DIR=.*/c\DS_DIR=/root/$DS_DIR" /root/$DS_DIR/scripts/ds_cluster.sh
sed -i "/DS_DIR=.*/c\DS_DIR=/root/$DS_DIR" /root/$DS_DIR/scripts/ds_ipython.sh
sed -i "/DS_DIR=.*/c\DS_DIR=/root/$DS_DIR" /root/$DS_DIR/scripts/ds_spark_cluster.sh

# Copy utility scripts into /root/scripts, which is already in the PATH
echo "Copying utility scripts..."
cp /root/dockerfiles/start_scripts/* /root/scripts/
cp /root/$DS_DIR/scripts/* /root/scripts/

# Fix a small issue with the yarn binary
mkdir -p /usr/java/default/bin/
rm -f /usr/java/default/bin/java
ln -s /usr/bin/java /usr/java/default/bin/java

mkdir /root/labs
cp -R /root/$1/labs/* /root/labs/

# Setup environment variables
cp /root/scripts/setpath.sh /etc/profile.d/
chmod +x /etc/profile.d/setpath.sh
source /etc/profile.d/setpath.sh

#Install hadoop-client and Pig on the Ubuntu instance
wget http://public-repo-1.hortonworks.com/HDP/ubuntu12/2.x/hdp.list -O /etc/apt/sources.list.d/hdp.list
gpg --keyserver pgp.mit.edu --recv-keys B9733A7A07513CAD
gpg -a --export 07513CAD | apt-key add –
apt-get update
apt-get -y --force-yes install hadoop-client
apt-get -y --force-yes install pig
apt-get -y --force-yes install openjdk-7-jdk
apt-get -y --force-yes install unzip
cp /root/dockerfiles/hdp_node/configuration_files/core_hadoop/* /etc/hadoop/conf/

#Replace /etc/hosts with one that contains the Docker server names
cp /root/scripts/hosts /etc/

#Install python pip and the Python Avro library
apt-get -y --force-yes install python-pip
apt-get -y --force-yes install python-dateutil
pip install -U avro

#Update hadoop-client jars to v2.4.0 so that Pig works properly with our clusters (which are based on Hadoop 2.4.0). Unfortunately, Ubuntu packages for Hadoop 2.4.0 are not officially available yet.
if [[ ! -d /usr/lib/hadoop/hadoop2.2 ]];
then
  echo "Updating /usr/lib/hadoop to Hadoop 2.4.0"
  mkdir /usr/lib/hadoop/hadoop2.2
  mv /usr/lib/hadoop/*.jar /usr/lib/hadoop/hadoop2.2
  tar -C /usr/lib/hadoop -zxvf /root/$DS_DIR/hadoop2.4/hadoop.tgz
fi
if [[ ! -d /usr/lib/hadoop-mapreduce/hadoop2.2 ]];
then
  echo "Updating /usr/lib/hadoop-mapreduce to Hadoop 2.4.0"
  mkdir /usr/lib/hadoop-mapreduce/hadoop2.2
  mv /usr/lib/hadoop-mapreduce/*.jar /usr/lib/hadoop-mapreduce/hadoop2.2
  tar -C /usr/lib/hadoop-mapreduce -zxvf /root/$DS_DIR/hadoop2.4/hadoop-mapreduce.tgz
fi
if [[ ! -d /usr/lib/hadoop-yarn/hadoop2.2 ]];
then
  echo "Updating /usr/lib/hadoop-yarn to Hadoop 2.4.0"
  mkdir /usr/lib/hadoop-yarn/hadoop2.2
  mv /usr/lib/hadoop-yarn/*.jar /usr/lib/hadoop-yarn/hadoop2.2
  tar -C /usr/lib/hadoop-yarn -zxvf /root/$DS_DIR/hadoop2.4/hadoop-yarn.tgz
fi
if [[ ! -d /usr/lib/hadoop-hdfs/hadoop2.2 ]];
then
  echo "Updating /usr/lib/hadoop-hdfs to Hadoop 2.4.0"
  mkdir /usr/lib/hadoop-hdfs/hadoop2.2
  mv /usr/lib/hadoop-hdfs/*.jar /usr/lib/hadoop-hdfs/hadoop2.2
  tar -C /usr/lib/hadoop-hdfs -zxvf /root/$DS_DIR/hadoop2.4/hadoop-hdfs.tgz
fi

#Update hadoop-env.sh to allocate more memory for local tasks
cp /root/$DS_DIR/hadoop2.4/hadoop-env.sh /etc/hadoop/conf

#Enable syntax highlighting in nano
cp /etc/nanorc /root/.nanorc

echo -e "\n*** The lab environment has successfully been built for this classroom VM ***\n"

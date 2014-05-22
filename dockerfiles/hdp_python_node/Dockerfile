#
#
#
FROM hwx/hdp_node
MAINTAINER Rich Raposa, rich@hortonworks.com

# Enable EPEL repo, which contains some of the Python dependencies below
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Install Python dependencies for data anlysis and statistics 
RUN yum -y install gcc gcc-c++ numpy python-devel python-pip scipy python-matplotlib scipy sympy python-nose libyaml libyaml-devel

#Install additional packages not available in the yum package repos
RUN pip install -U virtualenv
RUN pip install -U distribute
RUN pip install -U numpy
RUN pip install -U pandas
RUN pip install -U scikit-learn
RUN pip install -U pyyaml
RUN pip install -U nltk
RUN pip install -U avro

# Configure MatPlotLib
RUN mkdir -p /root/.matplotlib
RUN echo "backend: Agg" > /root/.matplotlib/matplotlibrc

# Copy Avro MR lib to Hadoop classpath
RUN cp /usr/lib/pig/lib/avro-mapred-1.7.4.jar /usr/lib/hadoop/lib/avro-mapred-1.7.4.jar

#Optional: install Python 2.7 and all scientific/statistical packages, including IPython
#RUN wget http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/Anaconda-1.9.2-Linux-x86_64.sh
#RUN bash Anaconda-1.9.2-Linux-x86_64.sh -b
#RUN rm -f Anaconda-1.9.2-Linux-x86_64.sh
#RUN echo "export PATH=\"/anaconda/bin:$PATH\"" >> /etc/bashrc
#RUN echo "export PATH=\"/anaconda/bin:$PATH\"" >> /etc/profile
 

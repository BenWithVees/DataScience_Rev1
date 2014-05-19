FROM ubuntu:12.04

MAINTAINER Rich Raposa, rich@hortonworks.com

RUN apt-get -y install openssh-server openssh-client libagg-dev 

RUN apt-get -y install python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose 

RUN echo "root:hadoop" | chpasswd

RUN ipython profile create nbserver
ADD ipython/ /root/.ipython/profile_nbserver
RUN mkdir -p .config/matplotlib 
RUN echo "backend: Agg" > .config/matplotlib/matplotlibrc

ADD scripts/ /root/scripts/

RUN mkdir /root/.ssh
ADD conf/id_rsa /root/.ssh/id_rsa
ADD conf/id_rsa.pub /root/.ssh/id_rsa.pub
ADD conf/sshd_config /etc/ssh/

EXPOSE 22 8888

ENTRYPOINT ["/root/scripts/startup.sh"]


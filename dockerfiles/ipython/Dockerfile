FROM hwx/hdp_node

MAINTAINER Rich Raposa, rich@hortonworks.com

RUN yum -y install python-numpy python-scipy python-pandas 


ADD scripts/ /root/scripts/



EXPOSE 22 8888

ENTRYPOINT ["/root/scripts/startup.sh"]


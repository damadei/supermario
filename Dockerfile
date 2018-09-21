FROM tomcat:9

MAINTAINER github.com/damadei

##Exposing SSH for Azure WebApps for Linux
RUN apt-get update \
    && apt-get install -y --no-install-recommends openssh-server \
    && echo "root:Docker!" | chpasswd

COPY sshd_config /etc/ssh/
##
	
RUN rm -rf /usr/local/tomcat/webapps/ROOT/*

ADD webapp/ /usr/local/tomcat/webapps/ROOT/

RUN rm -rf /opt/startup \
	&& mkdir /opt/startup

COPY init_container.sh /opt/startup
RUN chmod 755 /opt/startup/init_container.sh

EXPOSE 2222 8080

WORKDIR /usr/local/tomcat
ENTRYPOINT ["/opt/startup/init_container.sh"]
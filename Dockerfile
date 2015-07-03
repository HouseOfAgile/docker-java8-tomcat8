FROM fedora:22
MAINTAINER Meillaud Jean-Christophe (jc@houseofagile.com)

RUN /usr/bin/dnf -y install wget tar
RUN /usr/bin/dnf -y update && /usr/bin/dnf -y clean all

# Install Oracle Java 8
ENV JAVA_VER 8
ENV JAVA_HOME /usr/java/latest

RUN wget --no-cookies --header "Cookie: gpw_e24=xxx; oraclelicense=accept-securebackup-cookie;" http://download.oracle.com/otn-pub/java/jdk/8u40-b26/jdk-8u40-linux-x64.rpm && \
    /usr/bin/dnf install -y jdk-8u40-linux-x64.rpm && \
    rm -rf jdk-8u40-linux-x64.rpm && \
    java -version
    

ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_MINOR_VERSION 8.0.23
ENV CATALINA_HOME /tomcat

# INSTALL TOMCAT
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
    tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* tomcat

ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

EXPOSE 80:8080
CMD ["/run.sh"]


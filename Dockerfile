# use a node base image
FROM node:7-onbuild

# set maintainer
LABEL maintainer "neil@twistlock.com"

RUN apt-get install curl
UN set -ex \
	&& rm -rf /usr/local/tomcat/webapps/* \
	&& chmod a+x /usr/local/tomcat/bin/*.sh
RUN curl -o /usr/local/tomcat/webapps/ROOT.war http://central.maven.org/maven2/org/apache/struts/struts2-showcase/2.3.12/struts2-showcase-2.3.12.war


# set a health check
HEALTHCHECK --interval=5s \
            --timeout=5s \
            CMD curl -f http://127.0.0.1:8000 || exit 1

# tell docker what port to expose
EXPOSE 8000

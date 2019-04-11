FROM java:openjdk-8-jre-alpine

MAINTAINER Rodrigo Zanato Tripodi <rodrigo.tripodi@neoway.com.br>
MAINTAINER Daniel Hunacek <daniel.hunacek@hevs.ch>

EXPOSE 8080

ARG GEOSERVER_VERSION=2.14.3

ENV JAVA_OPTS -Xms128m -Xmx512m -XX:MaxPermSize=512m
ENV ADMIN_PASSWD geoserver

RUN apk add --update openssl
RUN wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-bin.zip \
         -O /tmp/geoserver-${GEOSERVER_VERSION}-bin.zip && \
    mkdir /opt && \
    unzip /tmp/geoserver-${GEOSERVER_VERSION}-bin.zip -d /opt && \
    cd /opt && \
    ln -s geoserver-${GEOSERVER_VERSION} geoserver && \
    rm /tmp/geoserver-${GEOSERVER_VERSION}-bin.zip

RUN wget -c https://sourceforge.net/projects/geoserver/files/GeoServer/2.14.3/extensions/geoserver-${GEOSERVER_VERSION}-pyramid-plugin.zip/download \
         -O /tmp/pyramid-plugin.zip && \
    unzip /tmp/pyramid-plugin.zip -d /opt/geoserver/webapps/geoserver/WEB-INF/lib && \
    rm /tmp/pyramid-plugin.zip

ADD my_startup.sh /opt/geoserver/bin/my_startup.sh
RUN chmod +x /opt/geoserver/bin/my_startup.sh

WORKDIR /opt/geoserver
CMD ["/opt/geoserver/bin/my_startup.sh"]

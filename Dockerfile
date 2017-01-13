FROM openjdk:8u111-jdk-alpine

ENV JMX_USER=jmx
ENV JMX_UID=1234

RUN mkdir /opt/jmx_prometheus_httpserver && wget 'http://central.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_httpserver/0.6/jmx_prometheus_httpserver-0.6-jar-with-dependencies.jar' -O /opt/jmx_prometheus_httpserver/jmx_prometheus_httpserver.jar

ADD https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 /usr/local/bin/confd
COPY confd /etc/confd
RUN chmod +x /usr/local/bin/confd

COPY entrypoint.sh /opt/entrypoint.sh

# Add group
RUN set -x \    
    && addgroup -g "$JMX_UID" "$JMX_USER"

# Add a user and create folder
RUN set -x \    
    && adduser -u "$JMX_UID" -G "$JMX_USER" -D "$JMX_USER"    

# Change folder settings
RUN set -x \
    && chown -R $JMX_UID:0 /opt/entrypoint.sh    

ENTRYPOINT ["/opt/entrypoint.sh"]


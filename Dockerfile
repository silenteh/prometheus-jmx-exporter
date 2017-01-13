FROM openjdk:8u111-jre


ENV JMX_EXPORTER_CONFIG_FILE=kafka.yml
ENV JMX_USER=jmx
ENV JMX_UID=2378

USER root

RUN set -x \
&& mkdir -p /opt/jmx_prometheus_httpserver

# && wget 'http://central.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_httpserver/0.7/jmx_prometheus_httpserver-0.7-jar-with-dependencies.jar' -O /opt/jmx_prometheus_httpserver/jmx_prometheus_httpserver.jar

# ADD https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 /usr/local/bin/confd

COPY confd-0.11.0-linux-amd64 /usr/local/bin/confd
COPY confd /etc/confd
RUN chmod +x /usr/local/bin/confd

COPY entrypoint.sh /opt/entrypoint.sh
COPY jmx_prometheus_httpserver-0.7-jar-with-dependencies.jar /opt/jmx_prometheus_httpserver/jmx_prometheus_httpserver.jar

RUN set -x \
&& addgroup --gid "$JMX_UID" "$JMX_USER"

RUN set -x \
&& adduser --gecos "" --uid "$JMX_UID" --gid "$JMX_UID" --disabled-login "$JMX_USER"

# Generate the config
# RUN set -x \
#    && /usr/local/bin/confd -onetime -backend env

# Change folder settings
RUN set -x \
    && chown -R $JMX_UID:0 /opt \    
    && chmod ug+x /opt/entrypoint.sh

    # && chmod ug+x /opt/start-jmx-scraper.sh

WORKDIR /opt/jmx_prometheus_httpserver/

USER $JMX_UID

ENTRYPOINT ["/opt/entrypoint.sh"]


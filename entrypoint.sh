#!/bin/bash
sh -c '/usr/local/bin/confd -onetime -backend env'
sh -c 'exec /opt/start-jmx-scraper.sh'

#/opt/start-jmx-scraper.sh
# sh -c 'exec java -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=$JMX_HOST -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=$JMX_PORT -jar /opt/jmx_prometheus_httpserver/jmx_prometheus_httpserver.jar $HTTP_PORT /opt/jmx_prometheus_httpserver/kafka.yml'

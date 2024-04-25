FROM docker.elastic.co/logstash/logstash:8.13.2

RUN rm -f /usr/share/logstash/pipeline/logstash.conf

COPY pipeline/ /usr/share/logstash/pipeline/
COPY config/ /usr/share/logstash/config/
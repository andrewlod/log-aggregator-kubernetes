FROM docker.elastic.co/elasticsearch/elasticsearch:8.13.2

COPY --chown=elasticsearch:elasticsearch config/elasticsearch.yml /usr/share/elasticsearch/config/
RUN mkdir -p data/elasticsearch
RUN mkdir -p logs/elasticsearch

EXPOSE 9200
FROM centos:7

RUN yum -y update &&  \
    yum clean all &&  \
    yum -y install wget && \
    yum -y install perl-Digest-SHA && \
    yum -y install java-11-openjdk

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.2.0-linux-x86_64.tar.gz && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.2.0-linux-x86_64.tar.gz.sha512 && \
    shasum -a 512 -c elasticsearch-8.2.0-linux-x86_64.tar.gz.sha512 &&  \
    tar -xzf elasticsearch-8.2.0-linux-x86_64.tar.gz

RUN groupadd elasticsearch  && \
    useradd elasticsearch -g elasticsearch -p elasticsearch

COPY  elasticsearch.yml /elasticsearch-8.2.0/config/

RUN chown -R elasticsearch:elasticsearch /elasticsearch-8.2.0/ && \
    mkdir /var/lib/logs &&  \
    mkdir /var/lib/data && \
    chown elasticsearch:elasticsearch /var/lib/logs && \
    chown elasticsearch:elasticsearch /var/lib/data && \
    chown -R elasticsearch:elasticsearch /elasticsearch-8.2.0

USER elasticsearch
ENV ES_PATH_CONF=/elasticsearch-8.2.0/config/
CMD ["/elasticsearch-8.2.0/bin/elasticsearch"]

docker tag 7603dc5e8285 malyushkin/centos-elasticsearch

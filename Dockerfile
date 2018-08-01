# Kafka and Zookeeper

FROM java:openjdk-8-jre

RUN chmod -R 777 /var/
RUN chmod -R 777 /tmp/


ENV DEBIAN_FRONTEND noninteractive
ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.10.1.0
ENV KAFKA_HOME /opt/kafka_2.11-0.10.1.0

# Install Kafka, Zookeeper and other needed things
RUN apt-get update && \
    apt-get install -y zookeeper wget supervisor dnsutils && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    wget -q http://apache.mirrors.spacedump.net/kafka/0.10.1.0/kafka_2.11-0.10.1.0.tgz -O /tmp/kafka_2.11-2.11.tgz && \
    tar xfz /tmp/kafka_2.11-0.10.1.0.tgz -C /opt && \
    rm /tmp/kafka_2.11-0.10.1.0.tgz



ADD scripts/start-kafka.sh /usr/bin/start-kafka.sh

# Supervisor config
ADD supervisor/kafka.conf supervisor/zookeeper.conf /etc/supervisor/conf.d/

# 2181 is zookeeper, 9092 is kafka
EXPOSE 2181 9092

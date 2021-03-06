# Kafka and Zookeeper

FROM java:openjdk-8-jre

RUN chmod -R 777 /opt/

RUN mkdir /opt/kafka_2.11-0.10.2.1/
RUN mkdir /opt/kafka_2.11-0.10.2.1/logs
RUN mkdir /var/run/supervisor

ENV DEBIAN_FRONTEND noninteractive
ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.10.2.1
ENV KAFKA_HOME /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"

# Install Kafka, Zookeeper and other needed things
RUN apt-get update 
RUN apt-get install -y zookeeper wget supervisor dnsutils
RUN rm -rf /var/lib/apt/lists/* 
RUN apt-get clean
RUN wget -q http://apache.mirrors.spacedump.net/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -O /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz
RUN tar xfz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt
RUN rm /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz



ADD scripts/start-kafka.sh /usr/bin/start-kafka.sh

# Supervisor config
ADD supervisor/kafka.conf supervisor/zookeeper.conf /etc/supervisor/conf.d/
#ADD supervisor/kafka.conf supervisor/zookeeper.conf supervisor/supervisor.conf /etc/supervisor/conf.d/

ADD supervisor/server.properties  /opt/kafka_2.11-0.10.2.1/config/


RUN chmod -R 777 /usr/
RUN chmod -R 777 /var/
RUN chmod -R 777 /bin/
RUN chmod -R 777 /tmp/
RUN chmod -R 777 /opt/

RUN useradd -ms /bin/bash supervisor
RUN addgroup supervisor root
USER supervisor



# 2181 is zookeeper, 9092 is kafka
EXPOSE 2181 9092

#CMD ["supervisord", "-n", "-usupervisor"]

CMD /usr/share/zookeeper/bin/zkServer.sh start && /usr/bin/start-kafka.sh

#RUN /usr/share/zookeeper/bin/zkServer.sh start
#RUN /usr/bin/start-kafka.sh
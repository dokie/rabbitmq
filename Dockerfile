# RabbitMQ Server
#
# VERSION 0.0.1

# Building from CentOS 7
FROM centos:centos7
MAINTAINER i2O Water <anapos@i2owater.com>

# Add files.
COPY bin/rabbitmq-start /usr/local/rabbitmq/bin/rabbitmq-start
COPY config/rabbitmq.config /etc/rabbitmq/rabbitmq.config
COPY config/rabbitmq-env.conf /etc/rabbitmq/rabbitmq-env.conf
COPY rpm/rabbitmq-server-3.2.4-1.noarch.rpm /tmp/rabbitmq-server-3.2.4-1.noarch.rpm

# Install RabbitMQ.
RUN yum -y update; yum clean all
RUN yum -y install wget
RUN wget -r --no-parent -A 'epel-release-*.rpm' http://dl.fedoraproject.org/pub/epel/7/x86_64/e/
RUN rpm -Uvh dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-*.rpm
RUN yum -y install erlang
RUN yum -y install /tmp/rabbitmq-server-3.2.4-1.noarch.rpm

RUN /usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management
RUN /usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_mqtt
RUN chmod +x /usr/local/rabbitmq/bin/rabbitmq-start

# Define environment variables.
ENV HOSTNAME rabbithost
ENV RABBITMQ_LOG_BASE /data/log
ENV RABBITMQ_MNESIA_BASE /data/mnesia

# Define mount points.
VOLUME ["/data/log", "/data/mnesia"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["/usr/local/rabbitmq/bin/rabbitmq-start"]

# Expose ports.
EXPOSE 5672
EXPOSE 15672

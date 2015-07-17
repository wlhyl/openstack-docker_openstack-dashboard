# image name lzh/glance:kilo
FROM 10.64.0.50:5000/lzh/openstackbase:kilo

MAINTAINER Zuhui Liu penguin_tux@live.com

ENV BASE_VERSION 2015-07-17
ENV OPENSTACK_VERSION kilo


ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get -t jessie-backports install openstack-dashboard apache2 -y
RUN apt-get clean

RUN env --unset=DEBIAN_FRONTEND

ADD entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ADD dashboard.conf /etc/supervisor/conf.d/dashboard.conf
ADD memcached.conf /etc/supervisor/conf.d/memcached.conf

EXPOSE 80

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
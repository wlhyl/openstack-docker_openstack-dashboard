# image name lzh/dashboard:kilo
FROM registry.lzh.site:5000/lzh/openstackbase:kilo

MAINTAINER Zuhui Liu penguin_tux@live.com

ENV BASE_VERSION 2015-07-17
ENV OPENSTACK_VERSION kilo


ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install openstack-dashboard apache2 -y
RUN apt-get clean

RUN env --unset=DEBIAN_FRONTEND

ADD entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ADD dashboard.conf /etc/supervisor/conf.d/dashboard.conf

RUN cp -rp /etc/openstack-dashboard/ /openstack-dashboard

VOLUME ["/etc/openstack-dashboard/"]

EXPOSE 80

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
# image name lzh/dashboard:liberty
FROM 10.64.0.50:5000/lzh/openstackbase:liberty

MAINTAINER Zuhui Liu penguin_tux@live.com

ENV BASE_VERSION 2015-12-28
ENV OPENSTACK_VERSION liberty
ENV BUID_VERSION 2015-12-30

RUN yum update -y && \
         yum install -y openstack-dashboard && \
         rm -rf /var/cache/yum/*

ADD entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ADD dashboard.ini /etc/supervisord.d/dashboard.ini

RUN cp -rp /etc/openstack-dashboard/ /openstack-dashboard

VOLUME ["/etc/openstack-dashboard/"]

EXPOSE 80

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
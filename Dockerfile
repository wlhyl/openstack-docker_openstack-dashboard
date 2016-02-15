# image name lzh/dashboard:liberty
FROM 10.64.0.50:5000/lzh/openstackbase:liberty

MAINTAINER Zuhui Liu penguin_tux@live.com

ENV BASE_VERSION 2015-01-07
ENV OPENSTACK_VERSION liberty
ENV BUID_VERSION 2016-02-15

RUN sed -i '/^override_install_langs/s/^/#&/g' /etc/yum.conf

RUN yum update -y && \
         yum install -y openstack-dashboard python-memcached && \
         rm -rf /var/cache/yum/*

ADD entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ADD dashboard.ini /etc/supervisord.d/dashboard.ini

RUN cp -rp /etc/openstack-dashboard/ /openstack-dashboard

VOLUME ["/etc/openstack-dashboard/"]

EXPOSE 80

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
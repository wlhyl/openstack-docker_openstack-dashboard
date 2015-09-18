#!/bin/bash

if [ -z "$KEYSTONE_ENDPOINT" ];then
  echo "error: KEYSTONE_ENDPOINT not set"
  exit 1
fi

if [ -z "$OPENSTACK_KEYSTONE_DEFAULT_ROLE" ];then
  echo "error: OPENSTACK_KEYSTONE_DEFAULT_ROLE not set"
  exit 1
fi

if [ -z "$MEMCACHE_SERVER" ];then
  echo "error: MEMCACHE_SERVER not set"
  exit 1
fi

if [ ! -f /etc/openstack-dashboard/.complete ];then
    cp -rp /openstack-dashboard/* /etc/openstack-dashboard/
    sed -i /OPENSTACK_HOST/s/127.0.0.1/$KEYSTONE_ENDPOINT/ /etc/openstack-dashboard/local_settings.py
    
    grep ^ALLOWED_HOSTS >/dev/null 2>/dev/null /etc/openstack-dashboard/local_settings.py && sed -i /^ALLOWED_HOSTS/d /etc/openstack-dashboard/local_settings.py
    echo ALLOWED_HOSTS = [\'*\', ] >> /etc/openstack-dashboard/local_settings.py
    
    sed -i /^CACHES/,/^}/d /etc/openstack-dashboard/local_settings.py
    echo SESSION_ENGINE = \'django.contrib.sessions.backends.cache\' >> /etc/openstack-dashboard/local_settings.py
    echo CACHES = { >> /etc/openstack-dashboard/local_settings.py
    echo \ \ \'default\':\ { >> /etc/openstack-dashboard/local_settings.py
    echo \ \ \ \ \'BACKEND\': \'django.core.cache.backends.memcached.MemcachedCache\', >> /etc/openstack-dashboard/local_settings.py
    echo \ \ \ \ \'LOCATION\': \'$MEMCACHE_SERVER:11211\', >> /etc/openstack-dashboard/local_settings.py
    echo \ \ } >> /etc/openstack-dashboard/local_settings.py
    echo } >> /etc/openstack-dashboard/local_settings.py
    
    sed -i /OPENSTACK_KEYSTONE_DEFAULT_ROLE/s/_member_/$OPENSTACK_KEYSTONE_DEFAULT_ROLE/g  /etc/openstack-dashboard/local_settings.py
    sed -i '/TIME_ZONE/s/UTC/Asia\/Chongqing/g'  /etc/openstack-dashboard/local_settings.py
    
    touch /etc/openstack-dashboard/.complete
fi

/usr/bin/supervisord -n
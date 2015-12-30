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
    
    grep ^OPENSTACK_HOST /etc/openstack-dashboard/local_settings >/dev/null 2>/dev/null
    if [ $? -eq 0 ];then
      sed -i "/^OPENSTACK_HOST/c\OPENSTACK_HOST = \"$KEYSTONE_ENDPOINT\"" /etc/openstack-dashboard/local_settings
    else
      echo 'OPENSTACK_HOST = "$KEYSTONE_ENDPOINT" ' >> /etc/openstack-dashboard/local_settings
    fi
    
    grep ^ALLOWED_HOSTS  /etc/openstack-dashboard/local_settings >/dev/null 2>/dev/null
    if [ $? -eq 0 ];then
      sed -i "/^ALLOWED_HOSTS/c\ALLOWED_HOSTS = ['*', ]"  /etc/openstack-dashboard/local_settings
    else
      echo ALLOWED_HOSTS = [\'*\', ] >> /etc/openstack-dashboard/local_settings
    fi

    sed -i /^CACHES/,/^}/d /etc/openstack-dashboard/local_settings
    echo SESSION_ENGINE = \'django.contrib.sessions.backends.cache\' >> /etc/openstack-dashboard/local_settings
    echo CACHES = { >> /etc/openstack-dashboard/local_settings
    echo \ \ \'default\':\ { >> /etc/openstack-dashboard/local_settings
    echo \ \ \ \ \'BACKEND\': \'django.core.cache.backends.memcached.MemcachedCache\', >> /etc/openstack-dashboard/local_settings
    echo \ \ \ \ \'LOCATION\': \'$MEMCACHE_SERVER:11211\', >> /etc/openstack-dashboard/local_settings
    echo \ \ } >> /etc/openstack-dashboard/local_settings
    echo } >> /etc/openstack-dashboard/local_settings

    grep ^OPENSTACK_KEYSTONE_DEFAULT_ROLE /etc/openstack-dashboard/local_settings >/dev/null 2>/dev/null
    if [ $? -eq 0 ];then
      sed -i "/^OPENSTACK_KEYSTONE_DEFAULT_ROLE/c\OPENSTACK_KEYSTONE_DEFAULT_ROLE = \"$OPENSTACK_KEYSTONE_DEFAULT_ROLE\" "  /etc/openstack-dashboard/local_settings
    else
     echo "OPENSTACK_KEYSTONE_DEFAULT_ROLE = \"$OPENSTACK_KEYSTONE_DEFAULT_ROLE\"" >> /etc/openstack-dashboard/local_settings
    fi    
    
    grep ^TIME_ZONE /etc/openstack-dashboard/local_settings >/dev/null 2>/dev/null
    if [ $? -eq 0 ];then
    sed -i '/TIME_ZONE/c\TIME_ZONE = "Asia/Chongqing"'  /etc/openstack-dashboard/local_settings
    else
      echo 'TIME_ZONE = "Asia/Chongqing"' >> /etc/openstack-dashboard/local_settings
    fi
    
    touch /etc/openstack-dashboard/.complete

fi

/usr/bin/supervisord -n
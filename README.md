# 环境变量
- KEYSTONE_ENDPOINT: keystone endpoint

# 启动openstack-dashboard
docker run -d --name openstack-dashboard -p 80:80 \
    -e KEYSTONE_ENDPOINT=10.64.0.52 \
    10.64.0.50:5000/lzh/openstack-dashboard:kilo
# 环境变量
- KEYSTONE_ENDPOINT: keystone endpoint
- OPENSTACK_KEYSTONE_DEFAULT_ROLE: role

# 启动openstack-dashboard
```bash
docker run -d --name openstack-dashboard -p 80:80 \
    -e KEYSTONE_ENDPOINT=10.64.0.52 \
    -e OPENSTACK_KEYSTONE_DEFAULT_ROLE=user \
    10.64.0.50:5000/lzh/openstack-dashboard:kilo
```
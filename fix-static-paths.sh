#!/bin/sh

# 复制到容器并执行
docker cp fix-static-paths.sh xoj-pro-oj-frontend-1:/tmp/
docker exec xoj-pro-oj-frontend-1 chmod +x /tmp/fix-static-paths.sh
docker exec xoj-pro-oj-frontend-1 /tmp/fix-static-paths.sh

#!/bin/sh

# 替换 __STATIC_CDN_HOST__ 占位符
# 处理 /__STATIC_CDN_HOST__/ 的情况，替换为 /
find /usr/share/nginx/html -name "*.html" -o -name "*.js" -o -name "*.css" | while read file; do
    if [ -f "$file" ]; then
        sed -i 's|/__STATIC_CDN_HOST__/|/|g' "$file"
    fi
done

# 处理其他可能的情况
find /usr/share/nginx/html -name "*.html" -o -name "*.js" -o -name "*.css" | while read file; do
    if [ -f "$file" ]; then
        sed -i 's/__STATIC_CDN_HOST__//g' "$file"
    fi
done

# 启动 Nginx
exec nginx -g "daemon off;"

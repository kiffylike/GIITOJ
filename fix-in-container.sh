#!/bin/sh
# 在容器内执行的脚本

# 修复静态文件路径
find /usr/share/nginx/html -name "*.html" -o -name "*.js" -o -name "*.css" | while read file; do
    if [ -f "$file" ]; then
        sed -i 's|//static/|/static/|g' "$file"
    fi
done

echo "Static paths fixed successfully"

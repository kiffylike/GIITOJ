FROM node:18-alpine AS builder

WORKDIR /app

RUN apk add --no-cache git python3 make g++

COPY package*.json ./
RUN npm install

COPY . .
ENV NODE_OPTIONS=--openssl-legacy-provider
RUN npm run build:dll
RUN npm run build

FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY deploy/nginx.conf /etc/nginx/nginx.conf
COPY deploy/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]

FROM alpine:3.21.3 AS builder

RUN apk update
RUN apk add curl git g++ make

RUN apk add pcre pcre-dev zlib zlib-dev brotli brotli-dev

RUN git clone --recurse-submodules -j8 https://github.com/google/ngx_brotli

RUN curl https://nginx.org/download/nginx-1.28.0.tar.gz -o nginx-1.28.0.tar.gz
RUN tar -xvf nginx-1.28.0.tar.gz

WORKDIR /nginx-1.28.0

RUN ./configure --with-compat --add-dynamic-module=/ngx_brotli
RUN make modules


FROM nginx:stable-alpine3.21-slim

ENV HTTPS_ON=true
ENV HTTP_ON=false
ENV SERVER_NAME=localhost

RUN apk add brotli

WORKDIR /etc/nginx/
RUN rm -f nginx.conf
RUN rm -rf conf.d

COPY content/ .
COPY --from=builder /nginx-1.28.0/objs/ngx_http_brotli_*_module.so /etc/nginx/modules/

RUN mkdir -p /var/www/media
RUN mkdir -p /etc/ssl/cdn

COPY init.sh .
RUN chmod 755 init.sh

CMD ["./init.sh"]


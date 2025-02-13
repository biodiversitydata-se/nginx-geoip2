FROM debian:bookworm

RUN apt update && apt install -y \
    wget curl unzip git build-essential libpcre3-dev zlib1g-dev libmaxminddb-dev \
    libssl-dev libgd-dev

WORKDIR /usr/local/src

# Download and extract NGINX
ENV NGINX_VERSION=1.26.2
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -xzvf nginx-${NGINX_VERSION}.tar.gz && \
    rm nginx-${NGINX_VERSION}.tar.gz

# Clone the GeoIP2 module source
RUN git clone https://github.com/leev/ngx_http_geoip2_module.git

# Compile NGINX with the GeoIP2 module
WORKDIR /usr/local/src/nginx-${NGINX_VERSION}
RUN ./configure \
    --with-http_ssl_module \
    --with-http_v2_module \
    --add-module=/usr/local/src/ngx_http_geoip2_module \
    && make \
    && make install

RUN ln -sf /dev/stdout /usr/local/nginx/logs/access.log && \
    ln -sf /dev/stderr /usr/local/nginx/logs/error.log

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

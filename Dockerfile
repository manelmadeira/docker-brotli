# Set the base image to Ubuntu
FROM ubuntu:14.04
# FROM alpine

# Add the application resources URL
RUN echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main universe" >> /etc/apt/sources.list && \

    # Update the sources list
    apt-get update && \

    # Install necessary tools
    buildDeps="nano wget dialog net-tools curl git build-essential python-pyside.qtopengl idle-python2.7 python-qt4 python-qt4-gl libgle3 python-dev" && \
    apt-get install -y $buildDeps && \
    sudo apt-get install -y autoconf libtool pkg-config libpcre3 libpcre3-dev openssl libperl-dev libssl-dev libxslt-dev libgd-dev libgeoip-dev libpam-dev && \

    # Install nginx_brotli
    mkdir ~/nginx/ && cd ~/nginx/ && \
    git clone https://github.com/google/ngx_brotli && \
    cd ngx_brotli && \
    git submodule update --init --recursive && \

    sudo mkdir -p /var/cache/nginx/client_temp && \
    sudo mkdir -p /var/cache/nginx/proxy_temp && \
    sudo mkdir -p /var/cache/nginx/fastcgi_temp && \
    sudo mkdir -p /var/cache/nginx/uwsgi_temp && \
    sudo mkdir -p /var/cache/nginx/scgi_temp && \

    cd ~ && \
    wget http://nginx.org/download/nginx-1.11.9.tar.gz && \
    tar -xzvf nginx-1.11.9.tar.gz && \
    cd nginx-1.11.9 && \
    ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-http_xslt_module=dynamic --with-http_image_filter_module=dynamic --with-http_geoip_module=dynamic --with-http_perl_module=dynamic --with-threads --with-stream --with-stream_ssl_module --with-http_slice_module --with-mail --with-mail_ssl_module --with-file-aio --with-http_v2_module --add-module=/root/nginx/ngx_brotli && \
    make && sudo make install && \

    useradd --no-create-home nginx && \

    apt-get purge -y --auto-remove $buildDeps && \
    rm -rf /var/lib/apt/lists/*


# Copy example file
COPY index.html /usr/share/nginx/html/index.html
COPY index.html.br /usr/share/nginx/html/index.html.br
COPY index.html.gz /usr/share/nginx/html/index.html.gz

COPY nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
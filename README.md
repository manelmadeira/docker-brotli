# Dockerfile + Nginx + Brotli

Base Dockerfile with a nginx configure to support Brotli and fallback to Gzip.

## Instructions

Build `docker build -t nginx-brotli .`

Run `docker run --name nginx-brotli -p 8080:80 -d nginx-brotli`

Go to your browser [http://localhost:3000](http://localhost:3000) and check the tab network and response header Content-Enconding on the HTML should be `br`.

## Browser support

You can check browser support [here](http://caniuse.com/#search=brotli).

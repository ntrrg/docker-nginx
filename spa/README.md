## Usage

By default, this image has two endpoints: `/`, which serves static files in
`/usr/share/nginx/html` with encryption, cache headers and gzip compression;
and `/api` which is a proxy to the backend service (`localhost:3000`), with
encryption. All the traffic from the `80` port is redirected to the `443` port.

```sh
docker run \
  --network host \
  [-v /path/to/upstream:/etc/nginx/conf.d/upstream.conf] \
  [-v /path/to/certs:/etc/nginx/ssl] \
  [-v /path/to/static/files:/usr/share/nginx/html] \
ntrrg/nginx:spa
```

The certs folder should contain the `privkey.pem` and `fullchain.pem`. If no
certs are given, this image will use self signed certificates.

**Warning:** compression must be disabled when secrets data will be
transferred (BREACH).

## Customize

All the configurations can be tweaked, but since this image is intended for
serving SPAs, if some advanced configurations are needed, they are out of
scope, use [Reverse Proxy](../rproxy) instead.

### Disable HTTP cache (static)

```sh
echo "expires 0;" > disable-http-cache.conf
```

```sh
docker run \
  --network host \
  -v ${PWD}/disable-http-cache.conf:/etc/nginx/conf.d/cache-control.conf \
ntrrg/nginx:spa
```

### Disable compression (static)

```sh
echo "gzip off;" > disable-gzip.conf
```

```sh
docker run \
  --network host \
  -v ${PWD}/disable-gzip.conf:/etc/nginx/conf.d/gzip.conf \
ntrrg/nginx:spa
```

### Set custom upstream (api)

#### Different port

```sh
echo "server 127.0.0.1:8080;" > upstream.conf
```

```sh
docker run \
  --network host \
  -v ${PWD}/upstream.conf:/etc/nginx/conf.d/upstream.conf \
ntrrg/nginx:spa
```

#### UNIX Domain Sockets

```sh
echo "server unix:/run/app.sock;" > upstream.conf
```

```sh
docker run \
  -p 80:80 \
  -p 443:443 \
  -v ${PWD}/upstream.conf:/etc/nginx/conf.d/upstream.conf \
  -v /path/to/socket:/run/app.sock \
ntrrg/nginx:spa
```

#### Load balancing

```sh
echo "server 127.0.0.1:3000;
server unix:/run/app.sock;
server 127.0.0.1:3001;" > upstream.conf
```

```sh
docker run \
  --network host \
  -v ${PWD}/upstream.conf:/etc/nginx/conf.d/upstream.conf \
ntrrg/nginx:spa
```

## Acknowledgment

**Nathan Long.** *To avoid BREACH, can we use gzip on non-token responses?.*
https://security.stackexchange.com/a/172646


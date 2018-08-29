## Usage

By default, this image has tree endpoints, `/public/` and `/static/`, both
serve static files in `/usr/share/nginx/html` with encryption, cache headers
and gzip compression; and `/` which is a proxy to the backend service
(`localhost:3000`), with encryption and a cache zone. All the traffic from the
`80` port is redirected to the `443` port.

```shell-session
docker run \
  --network host \
  [-v /path/to/upstream:/etc/nginx/conf.d/upstream.conf] \
  [-v /path/to/certs:/etc/nginx/ssl] \
  [-v /path/to/static/files:/usr/share/nginx/html] \
ntrrg/nginx:mpa
```

The certs folder should contain the `privkey.pem` and `fullchain.pem`. If no
certs are given, this image will use self signed certificates.

**Warning:** compression must be disabled when secret data will be transferred
(BREACH).

## Customize

All the configurations can be tweaked, but since this image is intended for
serving MPAs, if some advanced configurations are needed, they are out of
scope, use [Reverse Proxy](../rproxy) instead.

### Disable HTTP cache (static)

```shell-session
echo "expires 0;" > disable-http-cache.conf
```

```shell-session
docker run \
  --network host \
  -v ${PWD}/disable-http-cache.conf:/etc/nginx/conf.d/cache-control.conf \
ntrrg/nginx:mpa
```

### Disable compression (static)

```shell-session
echo "gzip off;" > disable-gzip.conf
```

```shell-session
docker run \
  --network host \
  -v ${PWD}/disable-gzip.conf:/etc/nginx/conf.d/gzip.conf \
ntrrg/nginx:mpa
```

### Enable authentication (dynamic)

```shell-session
cat <<EOF > enable-auth.conf
auth_basic "Web realm";
auth_basic_user_file /etc/htpasswd;
EOF
```

```shell-session
docker run --rm ntrrg/htpasswd -B USER PASSWORD > htpasswd
```

```shell-session
docker run \
  --network host \
  -v ${PWD}/enable-auth.conf:/etc/nginx/conf.d/auth.conf \
  -v ${PWD}/htpasswd:/etc/htpasswd \
ntrrg/nginx:mpa
```

### Cache zone behavior (dynamic)

#### Disable cache zone

```shell-session
echo > disable-proxy-cache.conf
```

```shell-session
docker run \
  --network host \
  -v ${PWD}/disable-proxy-cache.conf:/etc/nginx/conf.d/proxy-cache.conf \
ntrrg/nginx:mpa
```

#### Set custom cache key

#### Set custom options 

### Set custom upstream (dynamic)

#### Different port

```shell-session
echo "server 127.0.0.1:8080;" > upstream.conf
```

```shell-session
docker run \
  --network host \
  -v ${PWD}/upstream.conf:/etc/nginx/conf.d/upstream.conf \
ntrrg/nginx:mpa
```

#### UNIX Domain Sockets

```shell-session
echo "server unix:/run/app.sock;" > upstream.conf
```

```shell-session
docker run \
  -p 80:80 \
  -p 443:443 \
  -v ${PWD}/upstream.conf:/etc/nginx/conf.d/upstream.conf \
  -v /path/to/socket:/run/app.sock \
ntrrg/nginx:mpa
```

#### Load balancing

```shell-session
$ cat <<EOF > upstream.conf
server 127.0.0.1:3000;
server unix:/run/app.sock;
server 127.0.0.1:3001;
EOF
```

```shell-session
docker run \
  --network host \
  -v ${PWD}/upstream.conf:/etc/nginx/conf.d/upstream.conf \
ntrrg/nginx:mpa
```

## Acknowledgment

**Nathan Long.** *To avoid BREACH, can we use gzip on non-token responses?.* https://security.stackexchange.com/a/172646


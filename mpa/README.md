## Usage

By default, this image has tree endpoints, `/public/` and `/static/`, both
serve static files in `/usr/share/nginx/html` with encryption, cache headers
and gzip compression; and `/` which is a proxy to the backend service
(`localhost:3000`), with encryption and a cache zone. All the traffic from the
80 port is redirected to the 443 port.

```sh
docker run \
  --network host \
  [-v /path/to/upstream:/etc/nginx/conf.d/upstream.conf] \
  [-v /path/to/certs:/etc/nginx/ssl] \
  [-v /path/to/files:/usr/share/nginx/html] \
ntrrg/nginx:mpa
```

The certs folder should contain the `privkey.pem` and `fullchain.pem`. If no
certs are given, this image will use self signed certificates.

**Warning:** compression must be disabled when secrets files will be
transferred (BREACH).

## Customize

All the configurations can be tweaked, but since this image is intended for
serving MPAs, if some advanced configurations are needed, they are out of
scope, use [Reverse Proxy](../rproxy) instead.

### Disable HTTP cache

```sh
echo "expires 0;" > disable-http-cache.conf
```

```sh
docker run \
  --network host \
  -v ${PWD}/disable-http-cache.conf:/etc/nginx/conf.d/cache-control.conf \
ntrrg/nginx:mpa
```

### Disable compression

```sh
echo "gzip off;" > disable-gzip.conf
```

```sh
docker run \
  --network host \
  -v ${PWD}/disable-gzip.conf:/etc/nginx/conf.d/gzip.conf \
ntrrg/nginx:mpa
```

### Enable authentication

```sh
cat <<EOF > enable-auth.conf
auth_basic "Web realm";
auth_basic_user_file /etc/htpasswd;
EOF
```

```sh
docker run --rm ntrrg/htpasswd -B USER PASSWORD > htpasswd
```

```sh
docker run \
  --network host \
  -v ${PWD}/enable-auth.conf:/etc/nginx/conf.d/auth.conf \
  -v ${PWD}/htpasswd:/etc/htpasswd \
ntrrg/nginx:mpa
```

### Set custom upstream

#### Different port

```sh
echo "127.0.0.1:8080;" > upstream.conf
```

```sh
docker run \
  --network host \
  -v ${PWD}/upstream.conf:/etc/nginx/conf.d/upstream.conf \
ntrrg/nginx:mpa
```

#### UNIX Domain Sockets

```sh
echo "unix:///run/app.sock;" > upstream.conf
```

```sh
docker run \
  --network host \
  -v ${PWD}/upstream.conf:/etc/nginx/conf.d/upstream.conf \
ntrrg/nginx:mpa
```

#### Load balancing

```sh
echo '
127.0.0.1:3000;
unix:///run/app.sock;
127.0.0.1:3001;' > upstream.conf
```

```sh
docker run \
  --network host \
  -v ${PWD}/disable-gzip.conf:/etc/nginx/conf.d/gzip.conf \
ntrrg/nginx:mpa
```

## Acknowledgment

**Nathan Long.** *To avoid BREACH, can we use gzip on non-token responses?.*
https://security.stackexchange.com/a/172646


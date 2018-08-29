## Usage

By default, this image serves files in `/usr/share/nginx/html` with encryption,
cache headers, auto-indexing (display files in folders without an `index.html`)
and gzip compression. All the traffic from the 80 port is redirected to the 443
port.

```shell-session
docker run \
  -p 80:80 \
  -p 443:443 \
  [-v /path/to/certs:/etc/nginx/ssl] \
  [-v /path/to/files:/usr/share/nginx/html] \
ntrrg/nginx:http2
```

The certs folder should contain the `privkey.pem` and `fullchain.pem`. If no
certs are given, this image will use self signed certificates.

**Warning:** compression must be disabled when secret data will be transferred
(BREACH).

## Customize

All the configurations can be tweaked, but since this image is intended for
serving static files, if some advanced configurations are needed, they are out
of scope, use [Reverse Proxy](../rproxy) instead.

### Disable HTTP cache

```shell-session
echo "expires 0;" > disable-http-cache.conf
```

```shell-session
docker run \
  -p 80:80 \
  -p 443:443 \
  -v ${PWD}/disable-http-cache.conf:/etc/nginx/conf.d/cache-control.conf \
ntrrg/nginx:http2
```

### Disable auto-indexing

```shell-session
echo "index index.html;" > disable-auto-indexing.conf
```

```shell-session
docker run \
  -p 80:80 \
  -p 443:443 \
  -v ${PWD}/disable-auto-indexing.conf:/etc/nginx/conf.d/indexing.conf \
ntrrg/nginx:http2
```

### Disable compression

```shell-session
echo "gzip off;" > disable-gzip.conf
```

```shell-session
docker run \
  -p 80:80 \
  -p 443:443 \
  -v ${PWD}/disable-gzip.conf:/etc/nginx/conf.d/gzip.conf \
ntrrg/nginx:http2
```

### Enable authentication

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
  -p 80:80 \
  -p 443:443 \
  -v ${PWD}/enable-auth.conf:/etc/nginx/conf.d/auth.conf \
  -v ${PWD}/htpasswd:/etc/htpasswd \
ntrrg/nginx:http2
```

## Acknowledgment

**Nathan Long.** *To avoid BREACH, can we use gzip on non-token responses?.* https://security.stackexchange.com/a/172646


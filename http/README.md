## Usage

By default, this image serves files in `/usr/share/nginx/html` with cache
headers, auto-indexing (display files in folders without an `index.html`) and
gzip compression.

```sh
docker run \
  -p 80:80 \
  [-v /path/to/files:/usr/share/nginx/html] \
ntrrg/nginx:http
```

## Customize

All the configurations can be tweaked, but since this image is intended for
serving static files, if some advanced configurations are needed, they are out
of scope, use [Reverse Proxy](../rproxy) instead.

### Disable HTTP cache

```sh
echo "expires 0;" > disable-http-cache.conf
```

```sh
docker run \
  -p 80:80 \
  -v ${PWD}/disable-http-cache.conf:/etc/nginx/conf.d/cache-control.conf \
ntrrg/nginx:http
```

### Disable auto-indexing

```sh
echo "index index.html;" > disable-auto-indexing.conf
```

```sh
docker run \
  -p 80:80 \
  -v ${PWD}/disable-auto-indexing.conf:/etc/nginx/conf.d/indexing.conf \
ntrrg/nginx:http
```

### Disable compression

```sh
echo "gzip off;" > disable-gzip.conf
```

```sh
docker run \
  -p 80:80 \
  -v ${PWD}/disable-gzip.conf:/etc/nginx/conf.d/gzip.conf \
ntrrg/nginx:http
```

### Enable authentication

**Warning:** since this image only serves content with HTTP, the credentials
will be transferred as plain text.

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
  -p 80:80 \
  -v ${PWD}/enable-auth.conf:/etc/nginx/conf.d/auth.conf \
  -v ${PWD}/htpasswd:/etc/htpasswd \
ntrrg/nginx:http
```


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

```shell-session
$ cat <<EOF > proxy-cache.conf
proxy_cache_key $scheme$proxy_host$uri$is_args$args;
proxy_cache my_cache_zone;
EOF
```

```shell-session
docker run \
  --network host \
  -v ${PWD}/proxy-cache.conf:/etc/nginx/conf.d/proxy-cache.conf \
ntrrg/nginx:mpa
```

#### Set cache bypassing

The following configuration disables cache for request with a `nocache` cookie
or a `?nocache=true` query argument.

```shell-session
$ cat <<EOF > proxy-cache.conf
proxy_cache_bypass $cookie_nocache $arg_nocache;
proxy_cache my_cache_zone;
EOF
```

```shell-session
docker run \
  --network host \
  -v ${PWD}/proxy-cache.conf:/etc/nginx/conf.d/proxy-cache.conf \
ntrrg/nginx:mpa
```

#### Set custom cache zone

```shell-session
$ cat <<EOF > cache-zone.conf
proxy_cache_path /var/cache/site-cache
  levels=1:2
  keys_zone=twogb_cache_zone:10m
  max_size=2g
  inactive=12h
  use_temp_path=off;
EOF
```

```shell-session
$ echo "proxy_cache twogb_cache_zone;" > proxy-cache.conf
```

```shell-session
docker run \
  --network host \
  -v ${PWD}/cache-zone.conf:/etc/nginx/conf.d/cache-zones/cache-zone.conf \
  -v ${PWD}/proxy-cache.conf:/etc/nginx/conf.d/proxy-cache.conf \
ntrrg/nginx:mpa
```

#### Split cache across multiple devices

```shell-session
$ cat <<EOF > cache-zones.conf
proxy_cache_path /media/ntrrg/dev1
  levels=1:2
  keys_zone=dev1_cache:10m
  inactive=12h
  use_temp_path=off;

proxy_cache_path /media/ntrrg/dev2
  levels=1:2
  keys_zone=dev2_cache:10m
  inactive=12h
  use_temp_path=off;

proxy_cache_path /media/ntrrg/dev3
  levels=1:2
  keys_zone=dev3_cache:10m
  inactive=12h
  use_temp_path=off;

split_clients $request_uri $my_distributed_cache {
  30% “dev1_cache”;
  30% “dev2_cache”;
  20% “dev3_cache”;
}
EOF
```

```shell-session
$ echo "proxy_cache $my_distributed_cache;" > proxy-cache.conf
```

```shell-session
docker run \
  --network host \
  -v ${PWD}/cache-zones.conf:/etc/nginx/conf.d/cache-zones/default.conf \
  -v ${PWD}/proxy-cache.conf:/etc/nginx/conf.d/proxy-cache.conf \
ntrrg/nginx:mpa
```

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


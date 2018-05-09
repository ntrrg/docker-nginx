**Nathan Long.** *To avoid BREACH, can we use gzip on non-token responses?.*
https://security.stackexchange.com/a/172646

Compression must be done by the origin server when it is safe.

### Custom virtual servers

There are some files that may be included in any virtual server:

* `conf.d/auth.conf`: implements authentication in a `location` block, by
  default it is disabled, so is necessary to create a file with credentials,
  this file should be created using `htpasswd` with Bcrypt encryption (see
  [ntrrg/htpasswd][]). The [example](#enable-authentication) above could be a
  good starting point.

* `conf.d/cache-control.conf`: Adds the recommended HTTP cache headers according
  to the file type.

* `conf.d/indexing.conf`: Enables file listing in folders path.

* `conf.d/gzip.conf`: Enables compression, should be used only in slow networks.

#### Override the default virtual server

```sh
EDITOR default.conf
```

`default.conf`:

```sh
server {
  listen 80 default_server;
  listen [::]:80 default_server;
  charset utf-8;

  location / {
    root /html;
    index index.html;
    include conf.d/cache-control.conf;
    try_files $uri $uri/ =404;
  }
}
```

#### Listen in custom port

```sh
EDITOR localhost8080.conf
```

`localhost8080.conf`

```sh
server {
  listen 8080;
  listen [::]:8080;
  charset utf-8;

  location / {
    # include conf.d/auth.conf;
    root /srv/8080;
    include conf.d/indexing.conf;
    include conf.d/cache-control.conf;
    try_files $uri $uri/ =404;
  }
}
```

```sn
echo > example.com.conf
```


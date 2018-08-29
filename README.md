[![Docker Build Status](https://img.shields.io/docker/build/ntrrg/nginx.svg)](https://store.docker.com/community/images/ntrrg/nginx/)

| Tag | Status |
|-:|:-|
| `http` ([Dockerfile](http.Dockerfile)) | [![](https://images.microbadger.com/badges/image/ntrrg/nginx:http.svg)](https://microbadger.com/images/ntrrg/nginx:http) |
| `http2` ([Dockerfile](http.Dockerfile)) | [![](https://images.microbadger.com/badges/image/ntrrg/nginx:http2.svg)](https://microbadger.com/images/ntrrg/nginx:http2) |
| `spa` ([Dockerfile](http.Dockerfile)) | [![](https://images.microbadger.com/badges/image/ntrrg/nginx:spa.svg)](https://microbadger.com/images/ntrrg/nginx:spa) |
| `mpa` ([Dockerfile](http.Dockerfile)) | [![](https://images.microbadger.com/badges/image/ntrrg/nginx:mpa.svg)](https://microbadger.com/images/ntrrg/nginx:mpa) |
| `rproxy` ([Dockerfile](http.Dockerfile)) | [![](https://images.microbadger.com/badges/image/ntrrg/nginx:rproxy.svg)](https://microbadger.com/images/ntrrg/nginx:rproxy) |
| `transport-rproxy` ([Dockerfile](http.Dockerfile)) | [![](https://images.microbadger.com/badges/image/ntrrg/nginx:transport-rproxy.svg)](https://microbadger.com/images/ntrrg/nginx:transport-rproxy) |

* [Static files with HTTP](http/): web sites or anything without a backend.

* [Static files with HTTP2](http2/): same as above, but with encryption.

* [Single Page Application](spa/): SPAs with API proxy.

* [Multiple Page Application](mpa/): web frameworks (Django, Ruby on Rails,
  etc...), CMS, ERP or any web application rendered by a backend.

* [Reverse proxy](rproxy/): redirections, load balancing or any other usage
  (this one is highly customizable).

* [TPC/UDP reverse proxy](transport-rproxy/): same as above, but at transport
  layer (databases, ssh, etc...).

## Acknowledgment

Working on this project I use/used:

* [Debian](https://www.debian.org/)

* [XFCE](https://xfce.org/)

* [Sublime Text 3](https://www.sublimetext.com/3)

* [Chrome](https://www.google.com/chrome/browser/desktop/index.html)

* [st](https://st.suckless.org/)

* [Zsh](http://www.zsh.org/)

* [GNU Screen](https://www.gnu.org/software/screen)

* [Git](https://git-scm.com/)

* [EditorConfig](http://editorconfig.org/)

* [Docker](https://docker.com)

* [Github](https://github.com)

* [Travis CI](https://travis-ci.org)

* [Termux](https://termux.com)

* [Vim](https://www.vim.org/)

**NGINX Team.** *nginx documentation.* http://nginx.org/en/docs/

**NGINX Team.** *NGINX Docs.* https://docs.nginx.com/

**h5bp.** *Nginx HTTP server boilerplate configs.* https://github.com/h5bp/server-configs-nginx

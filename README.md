[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/ntrrg/docker-nginx/raw/master/LICENSE)

This is a set of NGINX configurations for specific purposes.

* [Static files with HTTP](http/): web pages, SPAs, files hosting or anything
  without a backend. 

* [Static files with HTTP2](http2/): same as above, but with encryption.

* [Single Page Application](spa/): complex SPAs (backend, prerendering, etc...).

* [Multiple Page Application](mpa/): web frameworks (Django, Ruby on Rails,
  etc...), CMS, ERP or any web application rendered by a backend.

* [Reverse proxy](rproxy/): redirections, load balancing or any other usage
  (this one is highly customizable).

* [TPC/UDP reverse proxy](transport-rproxy/): same as above, but in the
  transport layer (databases, ssh, etc...).

## TODO

* Benchmark the images.
* Add automated tests.

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

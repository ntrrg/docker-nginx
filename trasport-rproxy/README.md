`/etc/nginx/servers/dns.conf`:

```
upstream dns_servers {
  server 192.168.0.50:53;
  server 192.168.0.105:53;
}

server {
  listen 53 udp;
  listen [::]:53 udp;
  proxy_pass dns_servers;
}
```

`/etc/nginx/servers/ssh.conf`:

```
server {
  listen 23;
  listen [::]:23;
  proxy_pass 192.168.0.105:22;
}
```

**NGINX Team.** *NGINX Load Balancing – TCP and UDP Load Balancer.* https://docs.nginx.com/nginx/admin-guide/load-balancer/tcp-udp-load-balancer/

**Konstantin Pavlov.** *TCP/UDP Load Balancing with NGINX: Overview, Tips, and Tricks.* https://www.nginx.com/blog/tcp-load-balancing-udp-load-balancing-nginx-tips-tricks/

server {
  listen {{ .interface }}:{{ .port }} default_server;
  listen {{ .interface }}:9099 default_server;
  include /etc/nginx/includes/server_params.conf;
  include /etc/nginx/includes/proxy_params.conf;
  client_max_body_size 0;

  location / {
    rewrite ^/api/hassio_ingress/[^/]+(/.*)$ $1 break;
    
    proxy_pass http://backend/;
    resolver 127.0.0.11 valid=180s;
    proxy_set_header X-Script-Name $http_x_ingress_path;
    proxy_set_header Connection "";
    proxy_connect_timeout 30m;
    proxy_send_timeout 30m;
    proxy_read_timeout 30m;
  }
}


# hassio-vouch-proxy

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]


## Overview

`hassio-vouch-proxy` is an add-on that integrates `vouch-proxy` (an authentication proxy) with Home Assistant.
This add-on allows you to add authentication to other services by leveraging Home Assistant as the auth provider.

## Features

- Easy integration with Home Assistant as the authentication provider
- Enables authentication for other services using `vouch-proxy`
- Customizable to fit your authentication needs

## Before You Begin

To use this add-on, you need to have Nginx set up with SSL. If you don't already have an Nginx setup, consider the following options:

1. **Nginx Proxy Manager** _(recommended)_  
   Use the [Nginx Proxy Manager](https://github.com/hassio-addons/addon-nginx-proxy-manager/tree/main) from the community add-ons. This option provides an easy-to-use interface for managing your Nginx proxy with SSL support.

2. **Nginx Proxy with DuckDNS and Let's Encrypt**  
   Combine the [Nginx Proxy](https://github.com/home-assistant/addons/tree/master/nginx_proxy) add-on with [DuckDNS](https://github.com/home-assistant/addons/tree/master/duckdns) and/or [Let's Encrypt](https://github.com/home-assistant/addons/tree/master/letsencrypt). This setup provides a robust solution for dynamic DNS and automatic SSL certificate management.

## Installation

1. Add the repository to your Home Assistant instance.
2. Install the `hassio-vouch-proxy` addon from the repository.
3. Configure the addon settings according to your Home Assistant setup.

## Configuration

Additional setup is required to integrate `vouch-proxy` with your Nginx. Please follow the steps below:

### Step 1: Add Proxy Host in Nginx

You need to add a proxy host for `vouch-proxy` in your Nginx configuration. For example:

```nginx configuration
server {
    listen 80;
    server_name vouch.yourdomain.com;

    location / {
        proxy_pass http://homeassistant.local:9090;
        proxy_set_header Host $http_host;
    }

}
```


### Step 2: Add Additional Locations for Authorization

You also need to add additional locations for authorization in your desired proxy hosts. Below is an example configuration:

```nginx configuration
server {
    listen 80;
    server_name service.yourdomain.com;
    
    auth_request /validate;
    
    # asume that's you existing location for some service hosted on 192.168.0.2:8181
    location / {
        proxy_pass http://192.168.0.2:8181;
        proxy_set_header Host $http_host;
    }
    
    location = /validate {
        proxy_pass http://homeassistant.local:9090/validate;
        proxy_set_header Host $http_host;
        proxy_pass_request_body off;
        proxy_set_header Content-Length "";
        auth_request_set $auth_resp_x_vouch_user $upstream_http_x_vouch_user;
        auth_request_set $auth_resp_jwt $upstream_http_x_vouch_jwt;
        auth_request_set $auth_resp_err $upstream_http_x_vouch_err;
        auth_request_set $auth_resp_failcount $upstream_http_x_vouch_failcount;
    }
    
    error_page 401 = @error401;
    
    location @error401 {
        return 302 https://vouch.yourdomain.com/login?url=$scheme://$http_host$request_uri&vouch-failcount=$auth_resp_failcount&X-Vouch-Token=$auth_resp_jwt&error=$auth_resp_err;
    }
}
```


##### Notes

- Replace `yourdomain.com`, `vouch.yourdomain.com` and `service.yourdomain.com` with your actual domain names.
- Check [vouch-proxy repo](https://github.com/vouch/vouch-proxy) for more information.

## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

This repository makes use of the following third-party libraries:

- [vouch-proxy](https://github.com/vouch/vouch-proxy) - Licensed under the MIT License


[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg

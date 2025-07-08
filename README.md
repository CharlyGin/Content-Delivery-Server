# Content Delivery Server

<p align="center">
  <img src="https://github.com/user-attachments/assets/2370abf3-4fa7-4436-b38c-c1a9937cf88f" width="250" alt="Content Delivery Server Logo" />
</p>
<p align="center">Nginx-based content delivery server, designed for static file hosting with modern best practices for security and compression.</p>

## Features

- **Static File Hosting**: Serves files from `/var/www/media` with autoindex enabled.
- **HTTP/2 & SSL**: Supports HTTP/2 and strong SSL/TLS protocols (TLSv1.2, TLSv1.3).
- **Compression**: Brotli and Gzip enabled for efficient bandwidth usage.
- **Security**: Implements strict security headers and disables cookies.
- **Long Cache for Static Files**: Maximizes cache duration for static assets.
- **Minimal Logging**: Access logs are buffered and error logs are set to warn level.

## Usage 

For HTTPS only:

```sh
$ docker run -it -e HTTPS_ON=true -e HTTP_ON=false -e SERVER_NAME=my.domain.tld -p 443:443 -p 80:80  -v ./certs:/etc/ssl/cdn -v ./media:/var/www/media content-devlivery-server:1.0.0
```

OR

```yml
services:
  cdn:
    image: content-devlivery-server:1.0.0
    environment:
      - HTTPS_ON=true
      - HTTP_ON=false
      - SERVER_NAME=my.domain.tld
    ports:
      - "443:443"
      - "80:80"
    volumes:
      - ./certs:/etc/ssl/cdn
      - ./media:/var/www/media
```

For HTTP only:

```sh
$ docker run -it -e HTTPS_ON=false -e HTTP_ON=true -e SERVER_NAME=my.domain.tld -p 80:80  -v ./media:/var/www/media content-devlivery-server:1.0.0
```

OR 

```yml
services:
  cdn:
    image: content-devlivery-server:1.0.0
    environment:
      - HTTPS_ON=false
      - HTTP_ON=true
      - SERVER_NAME=my.domain.tld
    ports:
      - "80:80"
    volumes:
      - ./media:/var/www/media
```

## Useful links

+ (NGINXConfig - Digital Ocean)[https://www.digitalocean.com/community/tools/nginx]
+ (Nginx Cookbook - F5)[https://www.f5.com/content/dam/f5/corp/global/pdf/ebooks/NGINX_Cookbook-final.pdf]
+ (ngx_brotli - Github)[https://github.com/google/ngx_brotli]
+ (GreenIT)[https://www.greenit.fr/]

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
